#ifndef _GNU_SOURCE
#define _GNU_SOURCE 1
#endif

#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <string.h>
#include <signal.h>
#include <pthread.h>

const char* DELIMITER = "|";
const char* DELIMITER_COLOR = "#666666";

struct Block {
    pthread_mutex_t lock;
    char* command;
    char* result;
    size_t delay;
    size_t id;
};

struct Block_Array {
    struct Block* array;
    size_t n_blocks;
    size_t max_blocks;
};

struct Block_Array make(size_t max){
    struct Block_Array block_arr =  {
        .array = malloc(sizeof(struct Block) * max),
        .n_blocks = 0,
        .max_blocks = max,
    };

    return block_arr;
}

void insert(struct Block_Array* block_arr, struct Block* block){
    if(block_arr->n_blocks >= block_arr->max_blocks){
        block_arr->array = realloc(block_arr->array, sizeof(struct Block) * block_arr->max_blocks * 2);
        block_arr->max_blocks *= 2;
     }
     
     block_arr->array[block_arr->n_blocks] = *block;
     block_arr->n_blocks++;
}

struct Bar {
    struct Block_Array right;
    struct Block_Array center;
    struct Block_Array left;
};

struct Bar BAR_STATE;

enum BAR_AREA {
    left,
    right,
    center
};

struct Block_Array* get_block_array(enum BAR_AREA area){
    switch (area) {
        case left:
            return &BAR_STATE.left;
        case center:
            return &BAR_STATE.center;
        case right:
            return &BAR_STATE.right;
    }
}

struct Block* get_block(size_t signal_id){
    for (size_t i = 0; i < BAR_STATE.right.n_blocks; i++)
        if (BAR_STATE.right.array[i].id == signal_id)
            return &BAR_STATE.right.array[i];

    for (size_t i = 0; i < BAR_STATE.center.n_blocks; i++)
        if (BAR_STATE.center.array[i].id == signal_id)
            return &BAR_STATE.center.array[i];

    for (size_t i = 0; i < BAR_STATE.left.n_blocks; i++)
        if (BAR_STATE.left.array[i].id == signal_id)
            return &BAR_STATE.left.array[i];

    return NULL;
}

void draw_side(struct Block_Array block_arr, char* marker){
    printf("%%{%s}", marker);

    int print_delimiter = 1;
    for(size_t i = 0; i < block_arr.n_blocks; i++){

        pthread_mutex_lock(&block_arr.array[i].lock);

        if (block_arr.array[i].result)
            printf("%s", block_arr.array[i].result);
        else
            print_delimiter = 0;

        pthread_mutex_unlock(&block_arr.array[i].lock);

        if (i < block_arr.n_blocks - 1 && print_delimiter){
            printf("  %%{F%s}%s  ", DELIMITER_COLOR, DELIMITER);
        }

        print_delimiter = 1;
    }

    printf("%%{F-}");
}

void draw_bar() {
    if (BAR_STATE.right.n_blocks > 0)
        draw_side(BAR_STATE.right, "r");
    if (BAR_STATE.center.n_blocks > 0)
        draw_side(BAR_STATE.center, "c");
    if (BAR_STATE.left.n_blocks > 0)
        draw_side(BAR_STATE.left, "l");

    printf("\n");

    fflush(stdout);
}

void update_block(struct Block* block) {
    FILE *fp = popen(block->command ,"r");

    if (fp == NULL) {
        fputs("Failed to run command\n", stderr);
        return;
    }

    char line[1024];

    char* long_version = NULL;
    char* short_version = NULL;
    char* color = NULL;

    size_t n_lines_read = 0;
    while (fgets(line, sizeof(line), fp) != NULL) {
        n_lines_read++;
        switch (n_lines_read){
            case 1:
                long_version = strdup(line);
                strtok(long_version, "\n");
                break;
            case 2:
                short_version = strdup(line);
                strtok(short_version, "\n");
                break;
            case 3:
                color = strdup(line);
                strtok(color, "\n");
                break;
        }
    }

    char* new_result;

    if (n_lines_read == 0 || long_version[0] == '\n') {
        new_result = NULL;
    }
    else {
        asprintf(&new_result, "%%{F%s}%s", color?color:"-", long_version);
    }

    pthread_mutex_lock(&block->lock);

    free(block->result);
    block->result = new_result;

    pthread_mutex_unlock(&block->lock);

    free(long_version);
    free(short_version);
    free(color);
    pclose(fp);
}

void update_block_and_draw_bar(int signal_id){
    struct Block* block = get_block(signal_id);

    if (! block) return;

    update_block(block);
    draw_bar();
}

void* update_thread(void* signalid){
    size_t id = (size_t) signalid;
    struct Block* block = get_block(id);
    size_t delay = block->delay;

    while(1){
        sleep(delay);
        update_block_and_draw_bar(id);
    }

    pthread_exit(NULL);
}

void insert_block(enum BAR_AREA bar_area, char* block_comand, size_t delay){
    static size_t last_id_right = 34;
    static size_t last_id_other = 64;

    size_t new_id = (bar_area == right)?last_id_right++:last_id_other--;

    if (strstr(block_comand, "scripts/") == block_comand){
        asprintf(&block_comand, "~/.config/thonkbar/%s", block_comand);
    }

    struct Block block = {
        .command = block_comand,
        .delay = delay,
        .id = new_id
    };

    pthread_mutex_init(&block.lock, NULL);

    update_block(&block);

    insert(get_block_array(bar_area), &block);

    if (delay > 0) {
        pthread_t thread;
        int rc = pthread_create(&thread, NULL, update_thread, (void *)new_id);

        if (rc){
          printf("ERROR; return code from pthread_create() is %d\n", rc);
       }
    }

    signal(new_id, update_block_and_draw_bar);
}

int main (int argc, char** argv) {
    BAR_STATE.left = make(5);
    BAR_STATE.center = make(5);
    BAR_STATE.right = make(5);

    insert_block(right, "scripts/wifi", 5);
    insert_block(right, "blind --block", 0);
    insert_block(right, "deaf --block", 0);
    insert_block(right, "scripts/battery 1", 10);
    insert_block(right, "scripts/battery 0", 10);
    insert_block(right, "date '+\%d/%m  %H:%M   '", 1);

    insert_block(left, "scripts/workspaces", 0);
    insert_block(left, "uptime -p", 60);

    draw_bar();

    pthread_exit(NULL);
}
