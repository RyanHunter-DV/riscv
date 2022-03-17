module idecoder_top #(IW=32) (
	iClk,
	iResetn,
	iRcvFifoEmpty,
	iRcvInstrs,
	oReadFifo,
	fromIssue_ack,
	toIssue_vld,
	toIssue_instr0,
	toIssue_instr1,
	toIssue_instr2,
	toIssue_instr3
);

	output [IW-1:0] toIssue_instr0,toIssue_instr1,toIssue_instr2,toIssue_instr3;
	output toIssue_vld;


	assign {toIssue_instr3,toIssue_instr2,toIssue_instr1,toIssue_instr0}=
		oReadFifo? iRcvInstrs:{IW*4{1'b0}};

	assign toIssue_vld=oReadFifo;
	assign oReadFifo=(~iRcvFifoEmpty)&fromIssue_ack;

endmodule