NVCC = nvcc
CUOBJDUMP = cuobjdump
ARCH ?= -arch=sm_89

BIN_DIR = bin
PTX_DIR = ptx
DECOMP_DIR = $(PTX_DIR)/decompiled

vpath %.cu . cuda_codes

CU_FILES := $(wildcard *.cu) $(wildcard cuda_codes/*.cu)
TARGETS := $(basename $(notdir $(CU_FILES)))
BIN_TARGETS := $(addprefix $(BIN_DIR)/,$(TARGETS))
PTX_TARGETS := $(addprefix $(PTX_DIR)/,$(addsuffix .ptx,$(TARGETS)))

all: dirs $(BIN_TARGETS) $(PTX_TARGETS)

dirs:
	mkdir -p $(BIN_DIR) $(PTX_DIR) $(DECOMP_DIR)


$(BIN_DIR)/%: %.cu | dirs
	$(NVCC) $(ARCH) -O0 -o $@ $<

$(PTX_DIR)/%.ptx: %.cu | dirs
	$(NVCC) -ptx -O0 $< -o $@

decompile: dirs $(BIN_TARGETS)
	@echo "Decompiling to $(DECOMP_DIR)"
	@for file in $(TARGETS); do \
		$(CUOBJDUMP) -ptx $(BIN_DIR)/$$file > $(DECOMP_DIR)/$${file}_decompiled.ptx || true; \
	done

clean:
	rm -rf $(BIN_DIR) $(PTX_DIR)

.PHONY: all decompile clean dirs
