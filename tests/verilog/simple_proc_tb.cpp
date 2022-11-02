#include <stdlib.h>
#include <iostream>

#include <verilated.h>
#include <verilated_vcd_c.h>

#include "Vsimple_proc.h"
//#include "Vsimple_proc___024unit.h"

#define MAX_SIM_TIME 50
vluint64_t sim_time = 0;

const uint32_t NOP = 0b0010 << 28; // no-op
const uint32_t BRA = 0b0001 << 28 | 5; // 5 -> BB

int main(int argc, char **argv, char **env)
{
    Vsimple_proc *dut = new Vsimple_proc;

    Verilated::traceEverOn(true);
    VerilatedVcdC *m_trace = new VerilatedVcdC;
    dut->trace(m_trace, 5);
    m_trace->open("waveform.vcd");

    /* user init */

    /* init MEM */
    /* simple test of branch instruction */
    dut->simple_proc__DOT__MEM[0] = BRA;

    for (uint16_t i = 1; i < 255; i++)
    {
        // fill the rest of memory with NOP
        // if not the defaul opcode is 0 and the simulation stops
        dut->simple_proc__DOT__MEM[i] = NOP;
    }

    /* end user init */

    dut->nrst = 0;
    dut->datain = 1;

    while (sim_time < MAX_SIM_TIME)
    {
        dut->clk ^= 1; // invert clk signal

        if (sim_time >= 4)
        {
            dut->nrst = 1;
        }

        dut->eval();
        m_trace->dump(sim_time);
        sim_time++;
    }

    m_trace->close();
    delete dut;
    exit(EXIT_SUCCESS);
}