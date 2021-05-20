TESTS=$(wildcard tests/*.v)
WAVES=$(patsubst tests/%.v,waves/%.vcd,$(TESTS))

tests: $(WAVES)

clean:
	rm -rf build waves

.PHONY: clean tests

.PRECIOUS: $(patsubst tests/%.v,build/%,$(TESTS))

build:
	mkdir $@

waves:
	mkdir $@

build/%: tests/%.v build
	iverilog -o$@ -ylib -Wall -DOUTFILE=\"waves/$(*F).vcd\" $<

waves/%.vcd: build/% waves
	./$<