module ifetcher_pcCtrl #(PCW=32)(
	iClk,
	iResetn,
	// jump
	iJumpVld,
	iJumpPC,
	// with ifetcher_reqCtrl
	iNext,
	oPC
);

	input iClk,iResetn;
	input iNext;
	input iJumpVld;
	input [PCW-1:0] iJumpPC;
	output [PCW-1:0] oPC;
	
	reg [PCW-1:0] rPCCount;
	reg iNext_d1;

	always @(posedge iClk or negedge iResetn) begin
		if (!iResetn) begin
			rPCCount<={PCW{1'b0}};
			iNext_d1<=1'b0;
		end else begin
			if (iNext) begin
				rPCCount<=rPCOut+3'b100;
			end else begin
				rPCCount<=rPCCount;
			end
			iNext_d1<=iNext;
		end
	end

	assign @(*) begin
		case ({iNext_d1,iJumpVld})
			2'b01: oPC=iJumpPC;
			2'b10: oPC=rPCCount;
			2'b11: oPC=iJumpVld;
			default: oPC=oPC;
		endcase
	end

endmodule