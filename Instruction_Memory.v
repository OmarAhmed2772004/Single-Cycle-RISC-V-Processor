module Instruction_Memory
(
    input wire [31:0] A,  
    output [31:0] RD 
);


reg [31:0] memory [63:0];

initial begin
    $readmemh("program.txt", memory); 
end

assign RD = memory[A[31:2]]; 
endmodule