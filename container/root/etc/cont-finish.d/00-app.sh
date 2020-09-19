#!/usr/bin/execlineb -P

# backtick -n fluent_bit_pid { pidof fluent-bit }

# foreground { kill $fluent_bit_pid }
# s6-echo "[finish fluent-bit] shutting down gracefully"
