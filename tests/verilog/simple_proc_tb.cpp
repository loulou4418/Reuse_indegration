#include <stdlib.h>
#include <iostream>

#include <verilated.h>
#include <verilated_vcd_c.h>

#include "Vsimple_proc.h"
#include "simple_proc_tb_types.h"
//#include "Vsimple_proc___024unit.h"
#define MEMORY_SIZE 255
#define START_EXEC_SEGMENT 0
#define START_DATA_SEGMENT 128 /* from */

#define MAX_SIM_TIME 50
vluint64_t sim_time = 0;

const uint32_t NOP = 0b0010 << 28;     // no-op
const uint32_t BRA = 0b0001 << 28 | 5; // 5 -> BB

int main(int argc, char **argv, char **env)
{
    Vsimple_proc *dut = new Vsimple_proc;

    Verilated::traceEverOn(true);
    VerilatedVcdC *m_trace = new VerilatedVcdC;
    dut->trace(m_trace, 5);
    m_trace->open("waveform.vcd");

    /* user init */
    const uint32_t HLT = 0;
    STR_t STR;
    STR.field.OPCODE = 0b0011;
    LD_t LDA;
    LDA.field.OPCODE = 0b1000;
    LD_t LDB;
    LDB.field.OPCODE = 0b1001;
    MUL_t MUL;
    MUL.field.OPCODE = 0b0111;

    /* init executable and data memory */

    /* simple test of strore instruction STR */
    STR.field.IM = 1;
    STR.field.AA = 0xAF; /* idenfiable random value */
    STR.field.BB = START_DATA_SEGMENT + 1;
    dut->simple_proc__DOT__MEM[0] = STR.val;

    /* Select address in block ram */
    LDA.field.BB = 0x78; /* idenfiable random value */
    dut->simple_proc__DOT__MEM[1] = LDA.val;

    /* Select address in block ram */
    LDB.field.BB = 0x91; /* idenfiable random value */
    dut->simple_proc__DOT__MEM[2] = LDB.val;

    dut->simple_proc__DOT__MEM[3] = MUL.val;

    for (uint16_t i = 4; i < START_DATA_SEGMENT - 1; i++)
    {
        // fill the rest of memory with NOP
        // if not the defaul opcode is 0 and the simulation stops
        dut->simple_proc__DOT__MEM[i] = NOP;
    }
    dut->simple_proc__DOT__MEM[START_DATA_SEGMENT - 1] = HLT;

    /* end user init */

    dut->nrst = 0;
    dut->datain = 0;

    while (sim_time < MAX_SIM_TIME)
    {
        dut->clk ^= 1; // invert clk signal

        /* hold reset for 2 clock cycle*/
        if (sim_time >= 4)
        {
            dut->nrst = 1;
        }

        /* assert first STR test */
        if (dut->simple_proc__DOT__IR == STR.val && dut->clk == 1)
        {
            /* Store instr places AA on data bus and BB on address bus */
            if ((dut->address == START_DATA_SEGMENT + 1) &&
                (dut->dataout == 0xAF))
            {
                printf("Succes asserting STR test 1 \n");
            }
            else
            {
                printf("STR test 1 failed. Get address : %d, dataout %d \n", dut->address, dut->dataout);
            }
        }

        /* assert first LDA test */
        if (dut->simple_proc__DOT__IR == LDA.val)
        {
            dut->datain = 0x19; /* give ram cell value */

            if ((dut->address == 0x78) && dut->we == 0 && dut->simple_proc__DOT__reg_A == 0x19)
            {
                printf("Succes asserting LDA test 1 \n");
            }
            else
            {
                printf("LDA test 1 failed \n");
            }
        }

        /* assert first LDA test */
        if (dut->simple_proc__DOT__IR == LDB.val)
        {
            dut->datain = 0x02; /* give ram cell value */

            if ((dut->address == 0x91) && dut->we == 0 && dut->simple_proc__DOT__reg_B == 0x02)
            {
                printf("Succes asserting LDB test 1 \n");
            }
            else
            {
                printf("LDB test 1 failed \n");
            }
        }

        /* assert first LDA test */
        if (dut->simple_proc__DOT__IR == MUL.val)
        {
            if (dut->simple_proc__DOT__reg_A == (0x02 * 0x19))
            {
                printf("Succes asserting MUL test 1 \n");
            }
            else
            {
                printf("MUL test 1 failed \n");
            }
        }

        dut->eval();
        m_trace->dump(sim_time);
        sim_time++;
    }

    m_trace->close();
    delete dut;
    exit(EXIT_SUCCESS);
}