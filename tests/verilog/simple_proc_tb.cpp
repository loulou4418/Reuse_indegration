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
    STR_t STR;
    STR.field.OPCODE = 0b0011;

    const uint32_t HLT = 0;

    /* init executable and data memory */

    /* simple test of strore instruction STR */
    STR.field.IM = 1;
    STR.field.AA = 0xAF; /* idenfiable random value */
    STR.field.BB = START_DATA_SEGMENT + 1;
    dut->simple_proc__DOT__MEM[0] = STR.val;

    for (uint16_t i = 1; i < START_DATA_SEGMENT - 1; i++)
    {
        // fill the rest of memory with NOP
        // if not the defaul opcode is 0 and the simulation stops
        dut->simple_proc__DOT__MEM[i] = NOP;
    }
    dut->simple_proc__DOT__MEM[START_DATA_SEGMENT - 1] = HLT;

    /* end user init */

    dut->nrst = 0;
    dut->datain = 1;

    while (sim_time < MAX_SIM_TIME)
    {
        dut->clk ^= 1; // invert clk signal

        /* hold reset for 2 clock cycle*/
        if (sim_time >= 4)
        {
            dut->nrst = 1;
        }

        /* assert first STR test */
        if (dut->simple_proc__DOT__IR == STR.val)
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

        dut->eval();
        m_trace->dump(sim_time);
        sim_time++;
    }

    m_trace->close();
    delete dut;
    exit(EXIT_SUCCESS);
}