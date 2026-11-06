/* Exercise the pinned implementation directly; this is testing, not a proof. */
#include <stdint.h>
#include <stdio.h>
#include <limits.h>
#include "../libspng/spng/spng.c"

#if SIZE_MAX != UINT64_MAX
#error "This test targets a 64-bit size_t"
#endif

static int check(uint32_t width, uint32_t height)
{
    struct spng_ihdr ihdr = {0};
    ihdr.width = width;
    ihdr.height = height;
    size_t out = 123;
    int ret = calculate_image_size(&ihdr, SPNG_FMT_RGBA8, &out);
    __uint128_t expected = (__uint128_t) width * 4 * height;
    if (expected > SIZE_MAX) {
        if (ret != SPNG_EOVERFLOW || out != 123) return 1;
    } else if (ret != 0 || out != (size_t) expected) return 1;
    return 0;
}

int main(void)
{
    static const uint32_t vals[] = {1, 2, 3, 65535, 65536, 1000000,
        UINT32_MAX / 4, UINT32_MAX / 2, UINT32_MAX - 1, UINT32_MAX};
    size_t count = 0;
    for (size_t i = 0; i < sizeof(vals)/sizeof(vals[0]); i++)
        for (size_t j = 0; j < sizeof(vals)/sizeof(vals[0]); j++) {
            if (check(vals[i], vals[j])) return 1;
            count++;
        }
    uint32_t x = 0x12345678u;
    for (size_t i = 0; i < 10000; i++) {
        x = x * 1664525u + 1013904223u;
        uint32_t w = x | 1u;
        x = x * 1664525u + 1013904223u;
        uint32_t h = x | 1u;
        if (check(w, h)) return 1;
        count++;
    }
    printf("size calculations checked: %zu\n", count);
    return 0;
}
