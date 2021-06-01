TESTS=$(wildcard tests/*_tb.v)
WAVES=$(patsubst tests/%_tb.v,waves/%_tb.vcd,$(TESTS))
COMPONENTS=$(patsubst lib/%.v,%,$(wildcard lib/*.v))

# Phony recipes (MAKE commands)
tests: $(WAVES)

clean:
	rm -rf build waves

netwaves: waves/v0.vcd waves/v1.vcd

activity_data: activities_v0.txt activities_v1.txt

.PHONY: clean tests netwaves activity_data

# This keeps us from regenerating executables, which
#  saves us re-running tests we've already run.
.PRECIOUS: $(patsubst tests/%.v,build/%,$(TESTS))

# Generate some directories
build:
	mkdir $@

waves:
	mkdir $@

# Build an arbitrary _tb.v test file
build/%_tb: tests/%_tb.v build
	iverilog -o$@ -ylib -Wall -DOUTFILE=\"waves/$(@F).vcd\" $<

# Run the arbitrary _tb.v test file
waves/%_tb.vcd: build/%_tb waves
	./$<

# Generate rules to mandate the test be up to date if
#  the entire test name is the name of some component.
define COMP_TEST_gen_template
build/$(1)_tb: tests/$(1)_tb.v lib/$(1).v build
	iverilog -o$$@ -ylib -Wall -DOUTFILE=\"waves/$$(@F).vcd\" $$<

endef

$(eval $(foreach comp,$(COMPONENTS),$(call COMP_TEST_gen_template,$(comp))))


# Build the network test file
build/v%: net.v lib/iaf.v lib/tff.v lib/te.v lib/unit_buffer.v trained_weights.mem v%.mem build
	iverilog -o$@ -ylib -Wall -DOUTFILE=\"waves/$(@F).vcd\" -DWEIGHTFILE=\"trained_weights.mem\" -DINPUTFILE=\"$(@F).mem\" $<

# Translate the validation images
v%.mem: v%.im seq_mem_gen.py
	python3 seq_mem_gen.py $< $@

# Run the network simulation
waves/v%.vcd: build/v% v%.mem waves
	./$<

activities_v%.txt: waves/v%.vcd activities.py read_vcd.py
	python3 activities.py $< >$@
