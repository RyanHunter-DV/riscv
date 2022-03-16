module ifetcher_cachePort#(PCW=32,IW=32) (
	iClk,
	iResetn,
	// cache
	fromCache_resp,
	fromCache_instr,
	toCache_req,
	toCache_pc,
	// fifo
	iRcvFifoFull,
	oRcvFifoWE,
	oRcvFifoWD,
	// pcCtrl
	oNext,
	iPC,
	oCountDone,
	oCountEn
);

	input iClk,iResetn;
	input iRcvFifoFull;
	input fromCache_resp;
	input [PCW-1:0] iPC;
	input [IW*4-1:0] fromCache_instr;
	output toCache_req;
	output oNext;
	output [PCW-1:0] toCache_pc;
	output oCountDone;
	output [IW*4-1:0] oRcvFifoWD;
	output oCountEn;

	assign oNext=fromCache_resp;
	assign toCache_pc=iPC;
	assign oCountDone=fromCache_resp;
	assign oRcvFifoWD=fromCache_instr;
	assign oRcvFifoWE=fromCache_resp;

	reg rToCache_req;

	// toCache_req logic
	assign toCache_req=rToCache_req;
	assign oCountEn=rToCache_req;
	always @(posedge iClk or negedge iResetn) begin
		if (!iResetn) begin
			rToCache_req<=1'b0;
		end else begin
			case ({fromCache_resp,iRcvFifoFull})
				2'b01: rToCache_req<=1'b0;
				2'b10: rToCache_req<=1'b1;
				2'b11: rToCache_req<=1'b0;
				default: rToCache_req<=1'b1;
			endcase
		end
	end


endmodule