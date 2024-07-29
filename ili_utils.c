#include <asm/desc.h>

void my_store_idt(struct desc_ptr *idtr) {
// <STUDENT FILL> - HINT: USE INLINE ASSEMBLY
    asm ("sidt %0;"
        :"=m"(*idtr)::
        );
    return;
}

void my_load_idt(struct desc_ptr *idtr) {
// <STUDENT FILL> - HINT: USE INLINE ASSEMBLY

    asm ("lidt %0;"
        ::"m"(*idtr):
        );
    return;
}


//THE STRUCT USED IN THE FUNCTIONS


void my_set_gate_offset(gate_desc *gate, unsigned long addr) {
// <STUDENT FILL> - HINT: NO NEED FOR INLINE ASSEMBLY

    gate->offset_low = addr & 0xFFFF ;
    gate->offset_middle = (addr >> 16) & 0xFFFF;
    gate->offset_high = addr >> 32;
}

unsigned long my_get_gate_offset(gate_desc *gate) {
// <STUDENT FILL> - HINT: NO NEED FOR INLINE ASSEMBLY

    //get all 3 parts of the offset, aligned
    unsigned long return_value = gate->offset_high;
    return_value = return_value << 16;
    return_value = return_value + gate->offset_middle;
    return_value = return_value << 16;
    return_value = return_value + gate->offset_low;
    return return_value;
}
