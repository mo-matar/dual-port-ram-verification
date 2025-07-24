# Usage: make compile, make sim, make run, make clean

# Directories
TB_DIR = ../tb
TEST_DIR = ../tests
DUT_DIR = ../dut
RESULTS_DIR = ../results
LOG_DIR = $(RESULTS_DIR)/logs
COV_DIR = $(RESULTS_DIR)/coverage

# Source files
TB_SOURCES = $(TB_DIR)/interface.sv \
             $(TB_DIR)/transaction.sv \
             $(TB_DIR)/test_registry.sv \
             $(TB_DIR)/driver.sv \
             $(TB_DIR)/coverage.sv \
             $(TB_DIR)/monitor.sv \
             $(TB_DIR)/scoreboard.sv \
             $(TB_DIR)/generator.sv \
             $(TB_DIR)/enviroment.sv \
             $(TEST_DIR)/basic_test.sv \
             $(TB_DIR)/tb.sv

DUT_SOURCES = $(DUT_DIR)/dut.sv

# Simulation executable
SIMV = simv

# Default target
all: compile

# Compile target (without coverage)
compile: $(SIMV)

$(SIMV): $(TB_SOURCES) $(DUT_SOURCES)
	@echo "Compiling ALU testbench..."
	@mkdir -p $(LOG_DIR)
	vlogan -sverilog $(DUT_SOURCES) $(TB_SOURCES) -l $(LOG_DIR)/compile.log
	vcs -debug_access+all -full64 +vcs+vcdpluson tb -l $(LOG_DIR)/build.log
	@echo "Compilation completed!"
	@touch $(SIMV)

# Simulation target (without coverage)
sim: $(SIMV)
	@echo "Running simulation..."
	@mkdir -p $(LOG_DIR)
	./simv +vcs+vcdpluson -l $(LOG_DIR)/simulation.log +vcdfile=$(LOG_DIR)/dump.vcd
	@echo "Simulation completed!"

# Run everything (without coverage)
run: compile sim

# Coverage compilation target
compile-cov: 
	@echo "Compiling ALU testbench with coverage enabled..."
	@mkdir -p $(LOG_DIR)
	vlogan -sverilog $(DUT_SOURCES) $(TB_SOURCES) -l $(LOG_DIR)/compile_cov.log
	vcs -full64 -licqueue -timescale=1ns/1ns +vcs+flush+all +warn=all -sverilog -debug_access+all +vcs+vcdpluson -cm line+cond+fsm+branch+tgl tb -l $(LOG_DIR)/build_cov.log
	@echo "Coverage compilation completed!"

# Coverage simulation target
sim-cov:
	@echo "Running simulation with coverage..."
	@mkdir -p $(LOG_DIR) $(COV_DIR)
	./simv +vcs+vcdpluson -cm line+cond+fsm+branch+tgl -l $(LOG_DIR)/simulation_cov.log +vcdfile=$(LOG_DIR)/dump_cov.vcd +ntb_random_seed=456
	@echo "Coverage simulation completed!"
	@echo "Coverage database available in simv.vdb"

# View coverage in DVE GUI
view-cov:
	@echo "Opening DVE for coverage viewing..."
	dve -cov -dir simv.vdb &

# Generate coverage reports (HTML)
cov-report:
	@echo "Generating coverage reports..."
	@mkdir -p $(COV_DIR)
	urg -dir simv.vdb -report $(COV_DIR)
	@echo "Coverage reports generated in $(COV_DIR)/"
	@echo "Open $(COV_DIR)/dashboard.html in browser to view"

# Generate coverage reports (Text)
cov-report-text:
	@echo "Generating text coverage reports..."
	@mkdir -p $(COV_DIR)
	urg -dir simv.vdb -format text -report $(COV_DIR)
	@echo "Text coverage reports generated in $(COV_DIR)/"
	@echo "View with: cat $(COV_DIR)/*.txt"

# View coverage reports in browser (Linux)
view-report:
	@echo "Opening coverage report in browser..."
	firefox $(COV_DIR)/dashboard.html &

# Complete coverage flow
cov-flow: compile-cov sim-cov cov-report
	@echo "Complete coverage flow finished!"
	@echo "Coverage reports available in $(COV_DIR)/"

# Run coverage and view
run-cov: compile-cov sim-cov view-cov

# Clean build artifacts
clean:
	@echo "Cleaning build artifacts..."
	rm -rf $(SIMV)* csrc DVEfiles AN.DB *.log *.vcd *.vpd simv.daidir simv.vdb ucli.key
	@echo "Clean completed!"

# Clean everything including results
clean-all: clean
	rm -rf $(RESULTS_DIR)/*
	@echo "Full clean completed!"

# Help
help:
	@echo "Available targets:"
	@echo "  compile        - Compile the testbench"
	@echo "  sim            - Run simulation"
	@echo "  run            - Compile and simulate"
	@echo ""
	@echo "Coverage targets:"
	@echo "  compile-cov    - Compile with coverage enabled"
	@echo "  sim-cov        - Run simulation with coverage"
	@echo "  view-cov       - Open DVE for coverage viewing"
	@echo "  cov-report     - Generate HTML coverage reports"
	@echo "  cov-report-text- Generate text coverage reports"
	@echo "  view-report    - Open coverage report in browser"
	@echo "  cov-flow       - Complete coverage flow (compile+sim+report)"
	@echo "  run-cov        - Run coverage and open DVE"
	@echo ""
	@echo "Utility targets:"
	@echo "  clean          - Clean build artifacts"
	@echo "  clean-all      - Clean everything including results"
	@echo "  help           - Show this help message"

.PHONY: all compile sim run compile-cov sim-cov view-cov cov-report cov-report-text view-report cov-flow run-cov clean clean-all help
