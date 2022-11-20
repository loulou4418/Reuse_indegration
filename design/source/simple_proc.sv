//https://www.chipverify.com/verilog/verilog-introduction
module simple_proc #(
    // asic processor plus memory
    //declaration of parameters
    parameter
    step = 10,        // execution time of one instruction
    width = 32,       // data bus width
    addrsize = 8,    // address bus width (8 so that it does not crash with Verilator)
    memsize = 1<<addrsize,  // memory size
    sbits = 6        // number of status bits
  )(  input reg clk,
      input reg nrst,
      output reg we,
      input reg [width-1:0]datain ,
      output reg [addrsize-1:0]address ,
      output reg [width-1:0]dataout);

  reg[width-1:0] MEM[0:memsize-1]; // memory declaration
  reg [width-1:0]IR;                // instruction register declaration
  reg[sbits-1:0] SR;                // status register
  reg[addrsize-1:0] PC;             // program counter

  //definition of temp registers
  reg[width-1:0] reg_A, reg_B;
  reg write_A, write_B;

  // int instr_def;
  //definition of instruction fields
`define OPCODE IR[31:28]          // opcode
`define AA IR[23:12]              // operand AA
`define BB IR[addrsize-1:0]       // operand BB
`define IM IR[27]                 // operand type
  // 1: immediate
  // 0: memory
`define CCODE IR[27:24]           // branch condition
`define SHL IR[27]                // shift direction
  // 1: left
  // 0: right
`define SHD IR[16:12]             // shift distance


  //instruction codes
`define HLT 4'b0000             // halt
`define BRA 4'b0001             // branch
`define NOP 4'b0010             // no-op
`define STR 4'b0011             // store
`define SHF 4'b0100             // shift
`define CPL 4'b0101             // complement
`define ADD 4'b0110             // add
`define MUL 4'b0111             // multiply
`define LDA 4'b1000				// load into reg_A
`define LDB 4'b1001				// load into reg_B

  //condition code and status bit position
`define ALWAYS    0
`define CARRY     1
`define EVEN      2
`define PARITY    3
`define ZERO      4
`define NEG       5

  //set flags
  task setcondcode;
    input [width:0] RES;
    begin
      SR[`ALWAYS]     = 1;
      SR[`CARRY]      = RES[width];
      SR[`EVEN]       = ~RES[0];
      SR[`PARITY]     = ^RES;
      SR[`ZERO]       = ~(|RES);
      SR[`NEG]        = RES[width-1];
    end
  endtask

  //reset: start module
  initial
  begin
    PC = 0;            // start program
  end

  always @(write_A)
  begin
    if(write_A)
    begin
      reg_A <= datain;
    end
  end

  always @(write_B)
  begin
    if(write_B)
    begin
      reg_B <= datain;
    end
  end


  //main cycle for one instruction
  always @ (posedge clk,  negedge nrst)
  begin         // execution time of one instruction
    if (!nrst)
    begin
      we = 1;
      PC <= '0;
      IR = '0;
      reg_A = '0;
      reg_B = '0;
      SR = 'b00000001; // one for always flag
    end
    else
    begin
      IR = MEM[PC];     //instruction fetch
      PC <= PC + 1;       //increment program counter
      write_A <= 0;
      write_B <= 0;
      case(`OPCODE)
        `NOP:
          ;             //nothing to do
        `BRA:
        begin
          if (SR[`CCODE]) //branch check condition flags
            PC <= `BB;
        end
        `STR:
          if (`IM)
          begin           //store
            dataout[11:0] = `AA;         //immediate
            dataout[width-1:12] = '0;
            address = `BB;
            we = 1;
          end
          else
          begin
            case (`AA)
              0:
                dataout = reg_A;    //direct
              1:
                dataout = reg_B;
            endcase
            address = `BB;
            we = 1;
          end
        `ADD:
        begin
          reg_A[`BB] = reg_A[`AA] + reg_B[`BB];
          setcondcode(reg_B[`BB]);
        end
        `MUL:
        begin
          reg_A = reg_A * reg_B;
          setcondcode(reg_B);
        end
        `CPL:
        begin
          if (`IM)                 //complement store
            MEM[`BB] = ~`AA;         //immediate
          else
            MEM[`BB] = ~MEM[`AA];    //direct
          setcondcode(MEM[`BB]);
        end
        `SHF:
        begin
          if (`SHL)                 //shift
            MEM[`BB] = MEM[`BB] << `SHD;         //left
          else
            MEM[`BB] = MEM[`BB] >> `SHD;         //right
          setcondcode(MEM[`BB]);
        end
        `LDA:
        begin
          address = `BB;
          we = 0; // read
          //reg_A = datain;
          write_A <= 1;
        end
        `LDB:
        begin
          address = `BB;
          we = 0; // read
          //reg_B = datain;
          write_B <= 1;
        end
        `HLT:
          $finish ;                   // halt
        default:
          $display("erreur: mauvaise valeur dans op-code");
      endcase
    end
  end

endmodule

