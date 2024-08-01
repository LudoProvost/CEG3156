onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /pipelineprocessor_tb/clk
add wave -noupdate /pipelineprocessor_tb/topLevel/CLKdiv2
add wave -noupdate /pipelineprocessor_tb/reset
add wave -noupdate -radix hexadecimal /pipelineprocessor_tb/topLevel/fetchAddr8bit
add wave -noupdate -radix hexadecimal /pipelineprocessor_tb/topLevel/decodedInstr32bit_IF
add wave -noupdate -radix hexadecimal /pipelineprocessor_tb/topLevel/Registers/WriteReg
add wave -noupdate -radix hexadecimal /pipelineprocessor_tb/topLevel/Registers/WriteData
add wave -noupdate -radix hexadecimal /pipelineprocessor_tb/topLevel/Registers/Reg0out
add wave -noupdate -radix hexadecimal /pipelineprocessor_tb/topLevel/Registers/Reg1out
add wave -noupdate -radix hexadecimal /pipelineprocessor_tb/topLevel/Registers/Reg2out
add wave -noupdate -radix hexadecimal /pipelineprocessor_tb/topLevel/Registers/Reg3out
add wave -noupdate -radix hexadecimal /pipelineprocessor_tb/topLevel/Registers/Reg4out
add wave -noupdate -radix hexadecimal /pipelineprocessor_tb/topLevel/Registers/Reg5out
add wave -noupdate -radix hexadecimal /pipelineprocessor_tb/topLevel/Registers/Reg6out
add wave -noupdate -radix hexadecimal /pipelineprocessor_tb/topLevel/Registers/Reg7out
add wave -noupdate -radix hexadecimal /pipelineprocessor_tb/topLevel/Registers/RegWrite
add wave -noupdate -radix hexadecimal /pipelineprocessor_tb/topLevel/ID_EX_Buffer/controlRegOut
add wave -noupdate -radix hexadecimal /pipelineprocessor_tb/topLevel/EX_MEM_Buffer/output_WB_MEM
add wave -noupdate -radix hexadecimal /pipelineprocessor_tb/topLevel/MEM_WB_Buffer/controlRegOut
add wave -noupdate -radix hexadecimal /pipelineprocessor_tb/topLevel/WB_M_EX
add wave -noupdate -radix hexadecimal /pipelineprocessor_tb/topLevel/ExALU/A
add wave -noupdate -radix hexadecimal /pipelineprocessor_tb/topLevel/ExALU/B
add wave -noupdate -radix hexadecimal /pipelineprocessor_tb/topLevel/InstructBuffer/o_instruction2
add wave -noupdate /pipelineprocessor_tb/topLevel/ALU_Src_EX
add wave -noupdate /pipelineprocessor_tb/topLevel/rsSel
add wave -noupdate /pipelineprocessor_tb/topLevel/rtSel
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {256049 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 309
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {3150 ns}
