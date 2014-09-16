
# PlanAhead Launch Script for Post-Synthesis pin planning, created by Project Navigator

create_project -name lab2 -dir "M:/ECE3829/lab2/planAhead_run_1" -part xc6slx16csg324-3
set_property design_mode GateLvl [get_property srcset [current_run -impl]]
set_property edif_top_file "M:/ECE3829/lab2/lab2.ngc" [ get_property srcset [ current_run ] ]
add_files -norecurse { {M:/ECE3829/lab2} {ipcore_dir} }
set_param project.pinAheadLayout  yes
set_property target_constrs_file "seven_seg.ucf" [current_fileset -constrset]
add_files [list {seven_seg.ucf}] -fileset [get_property constrset [current_run]]
link_design
