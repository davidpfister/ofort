#include "ofort_fixed_form.h"

#include <stdio.h>
#include <stdlib.h>

static char *read_stream(FILE *fp) {
    size_t cap = 8192, len = 0;
    char *buf = (char *)malloc(cap);
    if (!buf) return NULL;
    for (;;) {
        size_t n;
        if (len + 4096 + 1 > cap) {
            char *p;
            cap *= 2;
            p = (char *)realloc(buf, cap);
            if (!p) { free(buf); return NULL; }
            buf = p;
        }
        n = fread(buf + len, 1, 4096, fp);
        len += n;
        if (n < 4096) {
            if (ferror(fp)) { free(buf); return NULL; }
            break;
        }
    }
    buf[len] = '\0';
    return buf;
}

int main(int argc, char **argv) {
    FILE *fp = stdin;
    char *source;
    char *converted;
    char *error = NULL;
    OfortFixedFormOptions opts = {72, 1, 0};

    if (argc > 2) {
        fprintf(stderr, "usage: %s [file.f]\n", argv[0]);
        return 2;
    }
    if (argc == 2) {
        fp = fopen(argv[1], "rb");
        if (!fp) {
            fprintf(stderr, "failed to open %s\n", argv[1]);
            return 2;
        }
    }
    source = read_stream(fp);
    if (fp != stdin) fclose(fp);
    if (!source) {
        fprintf(stderr, "failed to read input\n");
        return 2;
    }
    converted = ofort_fixed_to_free(source, argc == 2 ? argv[1] : "stdin", &opts, &error);
    free(source);
    if (!converted) {
        fprintf(stderr, "%s\n", error ? error : "fixed-form conversion failed");
        free(error);
        return 2;
    }
    fputs(converted, stdout);
    free(converted);
    return 0;
}
