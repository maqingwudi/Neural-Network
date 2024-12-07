`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/25 10:44:19
// Design Name: 
// Module Name: encoder
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module encoder(
    input Clk,Rst,Le,
    input[7:0] Din,
    input[3:0] N,
    output reg Dout
    );
    reg [7:0] input_reg [15:0];
    reg [3:0] N_reg;
    reg [7:0] N_counter;
    reg [2:0] S;
    reg [3:0]X;
    reg [2:0]Y;
    localparam S0=3'b000, S1=3'b001, S2=3'b010,S3=3'b011,S4=3'b100;
    integer i;
    
    always @(posedge Clk or negedge Rst) begin
        if(!Rst) begin
            N_counter<=0;
            S<=S0;
            X<=0;
            Y<=0;
            Dout<=0;
            N_reg<=0;
            for (i=0;i<=15;i=i+1) begin
                input_reg [i]<=8'b0;
            end
        end else 
        case (S)
        S0:
        if (Le)  begin 
            S<=S1;
            N_reg<=N;
            end
            else S<=S0;



            S1:begin
                input_reg[N_counter]<=Din;
                if (N_counter==(N+1)) begin 
                S<=S2;
                N_counter<=0;
                Dout<=0;
                end
                else begin 
                N_counter<=N_counter+1;
                S<=S1;
                end
            end
            
            S2:begin
            
                if (N_counter>=38) begin//记得减掉最后一个周期
                S<=S3;
                N_counter<=0;
                end
                else if (N_counter>=34)begin
                Dout<=0;
                N_counter<=N_counter+1;
                end
                else if (N_counter>=19)begin
                Dout<=1;
                N_counter<=N_counter+1;
                end
                else if (N_counter>=14)begin
                Dout<=0;
                N_counter<=N_counter+1;
                end
                else if (N_counter>=9) begin
                Dout<=1;
                N_counter<=N_counter+1;
                end
                else  N_counter<=N_counter+1;

            end
            
            S3:begin
                case (input_reg[X][Y])
                    0:begin 
                    if(N_counter<=4)begin
                    Dout<=1;
                    N_counter<=N_counter+1;
                    end
                    else if(N_counter<=8)begin
                    Dout<=0;
                    N_counter<=N_counter+1;
                    end
                    else if(N_counter==9)
                    N_counter<=0;
                    end
                    
                    1:begin
                     if(N_counter<=14)begin
                    Dout<=1;
                    N_counter<=N_counter+1;
                    end
                    else if(N_counter<=18)begin
                    Dout<=0;
                    N_counter<=N_counter+1;
                    end
                    else if(N_counter==19)
                    N_counter<=0;
                    end
                    
  
                endcase
                
                      if ((X==N)&&(Y==7)) begin
                        S<=S4;
                        N_counter<=0;
                    end else if(Y==7)
                        X<=X+1;
                    Y<=Y+1;
                end
                
            S4:begin
                    if(N_counter<=9)begin
                    Dout<=0;
                    N_counter<=N_counter+1;
                    end
                    else if(N_counter<=14)begin
                    Dout<=1;
                    N_counter<=N_counter+1;
                    end
                    else if(N_counter==19)begin
                    N_counter<=0;
                    S<=S0;
                    end
                end
        endcase
    end

endmodule