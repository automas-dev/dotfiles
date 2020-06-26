#pragma once

#include <stdio.h>
#include <stdlib.h>

static __inline void pass(__attribute__ ((unused)) const char *name) {
    printf(": PASS\n");
}

static __inline void fail(__attribute__ ((unused)) const char *name) {
    printf(": FAIL\n");
}

static __inline void fatal(__attribute__ ((unused)) const char *name) {
    printf(": FAIL\n");
    exit(EXIT_FAILURE);
}

#define TEST(NAME)              \
    {                           \
        printf("%10s ", #NAME); \
        fflush(stdout);         \
        int err = NAME();       \
        if (err == -1)          \
            fail(#NAME);        \
        else if (err == 1)      \
            fatal(#NAME);       \
        else                    \
            pass(#NAME);        \
    }

#define ASSERT_EQ(a, b)                                                 \
    if ((a) != (b)) {                                                       \
        fprintf(stderr, "ASSERT_EQ fail! %s:%d ", __func__, __LINE__); \
        return -1;                                                      \
    }
#define ASSERT_NOT_EQ(a, b)                                                 \
    if ((a) == (b)) {                                                           \
        fprintf(stderr, "ASSERT_NOT_EQ fail! %s:%d ", __func__, __LINE__); \
        return -1;                                                          \
    }
#define ASSERT_TRUE(a)                                                    \
    if (!(a)) {                                                             \
        fprintf(stderr, "ASSERT_TRUE fail! %s:%d ", __func__, __LINE__); \
        return -1;                                                        \
    }
#define ASSERT_FALSE(a)                                                    \
    if (a) {                                                               \
        fprintf(stderr, "ASSERT_FALSE fail! %s:%d ", __func__, __LINE__); \
        return -1;                                                         \
    }
#define FATAL                                                    \
    fprintf(stderr, "FATAL ERROR! %s:%d ", __func__, __LINE__); \
    return 1;
