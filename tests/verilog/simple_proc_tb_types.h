#include <stdint.h>


/* STR instruction structure */
#pragma pack(push, 4)
typedef struct
{
    uint16_t BB : 12;
    uint16_t AA : 12;
    uint8_t RESERVED : 3;
    uint8_t IM : 1;
    uint8_t OPCODE : 4;
} _STR_t ;
#pragma pack(pop)
static_assert(sizeof(_STR_t) == 4, "error not packed");


typedef union
{
    _STR_t field;
    uint32_t val;
} STR_t;

