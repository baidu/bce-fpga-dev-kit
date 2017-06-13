
CC = gcc

CFLAGS = -Wall

BINDIR = bin

TARGET = xvc_pcie

OBJDIR := obj
OBJS := $(addprefix $(OBJDIR)/,xvc_pcie.o xvcserver.o)

$(OBJDIR)/%.o : %.c
	@$(CC) $(CFLAGS) -c $< -o $@

all: $(OBJS)
	$(CC) $(CFLAGS) -o $(BINDIR)/$(TARGET) $(OBJS)

$(OBJS): | $(OBJDIR)

$(OBJDIR):
	@mkdir -p $(OBJDIR)
	@mkdir -p $(BINDIR)

clean: 
	@$(RM) -r $(OBJDIR)
	@$(RM) -r $(BINDIR)
