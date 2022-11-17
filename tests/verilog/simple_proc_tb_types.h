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
} _STR_t;
#pragma pack(pop)
static_assert(sizeof(_STR_t) == 4, "error _STR_t not packed");

typedef union
{
    _STR_t field;
    uint32_t val;
} STR_t;

/* LDx instruction structure (LDA and LDB)
Only the opcode chages between these instruction */
#pragma pack(push, 4)
typedef struct
{
    uint16_t BB : 12;
    uint16_t RESERVED : 16;
    uint8_t OPCODE : 4;
} _LD_t;
#pragma pack(pop)
static_assert(sizeof(_LD_t) == 4, "error _LD_t not packed");

typedef union
{
    _LD_t field;
    uint32_t val;
} LD_t;

/* MUL instruction structure */
#pragma pack(push, 4)
typedef struct
{
    uint32_t RESERVED : 28;
    uint8_t OPCODE : 4;
} _MUL_t;
#pragma pack(pop)
static_assert(sizeof(_MUL_t) == 4, "error _MUL_t not packed");

typedef union
{
    _MUL_t field;
    uint32_t val;
} MUL_t;
