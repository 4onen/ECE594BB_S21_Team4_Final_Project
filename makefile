TESTS=$(wildcard tests/*_tb.v)
WAVES=$(patsubst tests/%_tb.v,waves/%_tb.vcd,$(TESTS))
COMPONENTS=$(patsubst lib/%.v,%,$(wildcard lib/*.v))

# Phony recipes (MAKE commands)
tests: $(WAVES)

clean:
	rm -rf build waves

.PHONY: clean tests

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

