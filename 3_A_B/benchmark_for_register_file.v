//6.3.a-b
module regFileBenchmark();


reg reset, clk;


MCPU cpuinst (clk, reset);


initial begin
  reset=1;
  #10  reset=0;
end

always begin
  #5 clk=0; 
  #5 clk=1; 
end


/********OUR ASSEMBLER*****/

integer file, i;
reg[cpuinst.WORD_SIZE-1:0] memi;
parameter  [cpuinst.OPERAND_SIZE-1:0]  R0  = 0; //4'b0000
parameter  [cpuinst.OPERAND_SIZE-1:0]  R1  = 1; //4'b0001
parameter  [cpuinst.OPERAND_SIZE-1:0]  R2  = 2; //4'b0010
parameter  [cpuinst.OPERAND_SIZE-1:0]  R3  = 3; //4'b0011
parameter  [cpuinst.OPERAND_SIZE-1:0]  R4  = 4; //4'b0100
parameter  [cpuinst.OPERAND_SIZE-1:0]  R5  = 5; //4'b0101
parameter  [cpuinst.OPERAND_SIZE-1:0]  R6  = 6; //4'b0110
parameter  [cpuinst.OPERAND_SIZE-1:0]  R7  = 7; //4'b0111
parameter  [cpuinst.OPERAND_SIZE-1:0]  R8  = 8; //4'b1000
parameter  [cpuinst.OPERAND_SIZE-1:0]  R9  = 9; //4'b1001
parameter  [cpuinst.OPERAND_SIZE-1:0]  R10  = 10; //4'b1010
parameter  [cpuinst.OPERAND_SIZE-1:0]  R11  = 11; //4'b1011
parameter  [cpuinst.OPERAND_SIZE-1:0]  R12  = 12; //4'b1100
parameter  [cpuinst.OPERAND_SIZE-1:0]  R13  = 13; //4'b1101
parameter  [cpuinst.OPERAND_SIZE-1:0]  R14  = 14; //4'b1110
parameter  [cpuinst.OPERAND_SIZE-1:0]  R15  = 15; //4'b1111

initial
begin

    for(i=0;i<256;i=i+1)
    begin
      cpuinst.raminst.mem[i]=0;
    end
    
    for(i=0;i<16;i=i+1)
    begin
      cpuinst.regfileinst.R[i]=0;
    end   
    
                                                                                //memory address: instruction
    i=0;  cpuinst.raminst.mem[0]={cpuinst.OP_SHORT_TO_REG, R0, 8'b00000000};   //0: R0=0;
    i=i+1;cpuinst.raminst.mem[i]={cpuinst.OP_SHORT_TO_REG, R1, 8'b00000001};   //1: R1=1;
    i=i+1;cpuinst.raminst.mem[i]={cpuinst.OP_SHORT_TO_REG, R2, 8'b00000010};   //2: R2=2;
                                                                               //do{
    i=i+1;cpuinst.raminst.mem[i]={cpuinst.OP_SHORT_TO_REG, R10, 8'b00100001};  //3: R10=33;
    i=i+1;cpuinst.raminst.mem[i]={cpuinst.OP_SHORT_TO_REG, R11, 8'b00010101};  //4: R11=21;
    i=i+1;cpuinst.raminst.mem[i]={cpuinst.OP_STORE_TO_MEM, R10, 8'b01100100};  //5: mem[100]=R10;
    i=i+1;cpuinst.raminst.mem[i]={cpuinst.OP_STORE_TO_MEM, R11, 8'b01100101};  //6: mem[101]=R11;
    i=i+1;cpuinst.raminst.mem[i]={cpuinst.OP_LOAD_FROM_MEM, R12, 8'b01100100}; //7: R12=mem[100];
    i=i+1;cpuinst.raminst.mem[i]={cpuinst.OP_LOAD_FROM_MEM, R13, 8'b01100101}; //8: R13=mem[101];
    i=i+1;cpuinst.raminst.mem[i]={cpuinst.OP_ADD, R5, R12, R13}; //9: R5=R12+R13;
    i=i+1;cpuinst.raminst.mem[i]={cpuinst.OP_XOR, R6, R12, R13}; //10: R6=R12^R13;
    
    i=i+1;cpuinst.raminst.mem[i]={cpuinst.OP_SHORT_TO_REG, R14, 8'b11111111};  //11: R14=255;
    i=i+1;cpuinst.raminst.mem[i]={cpuinst.OP_MOV, R0, R1, 4'b0000};            //12: R1=R0;
    i=i+1;cpuinst.raminst.mem[i]={cpuinst.OP_MOV, R1, R2, 4'b0000};            //13: R1=R2;
    i=i+1;cpuinst.raminst.mem[i]={cpuinst.OP_ADD, R2, R0, R1};                 //14: R2=R0+R1;
    i=i+1;cpuinst.raminst.mem[i]={cpuinst.OP_STORE_TO_MEM, R2, 8'b00010100};   //15:mem[20]=R2;
    i=i+1;cpuinst.raminst.mem[i]={cpuinst.OP_LOAD_FROM_MEM, R3, 8'b00010100};  //16:R3=mem[20];
    i=i+1;cpuinst.raminst.mem[i]={cpuinst.OP_ADD, R0, R0, R0};                 //17:R0=R0+R0
                                                                               //}
    i=i+1;cpuinst.raminst.mem[i]={cpuinst.OP_BNZ, R2, 8'b00000011};
    
    
    file = $fopen("program.list","w");
    for(i=0;i<cpuinst.raminst.RAM_SIZE;i=i+1)
    begin
      memi=cpuinst.raminst.mem[i];
      
      $fwrite(file, "%b_%b_%b_%b\n", 
        memi[cpuinst.INSTRUCTION_SIZE-1:cpuinst.INSTRUCTION_SIZE-cpuinst.OPCODE_SIZE],
        memi[cpuinst.OPCODE_SIZE*3-1:2*cpuinst.OPCODE_SIZE],
        memi[cpuinst.OPCODE_SIZE*2-1:cpuinst.OPCODE_SIZE],
        memi[cpuinst.OPCODE_SIZE-1:0]);
    end
    $fclose(file);
end

endmodule

