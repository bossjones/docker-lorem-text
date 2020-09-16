#!/usr/bin/execlineb -P

# backtick -n fluent_bit_pid { pidof fluent-bit }

# foreground { kill $fluent_bit_pid }
# echo "[finish fluent-bit] shutting down gracefully"
