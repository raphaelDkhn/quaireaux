//! Heap implementation
//!
//! # Example
//! ```
//! use quaireaux::data_structures::heap::HeapTrait;

// Core lib imports
use array::ArrayTrait;
use option::OptionTrait;

const ZERO_USIZE: usize = 0_usize;

#[derive(Drop)]
struct Heap {
    items: Array::<felt>,
}

trait HeapTrait {
    fn new() -> Heap;
    fn len(self: @Heap) -> usize;
    fn is_empty(self: @Heap) -> bool;
    fn add(ref self: Heap, value: felt);
    fn child_present(self: @Heap, idx: usize) -> bool;
    fn right_child_idx(self: @Heap, idx: usize) -> usize;
    fn smallest_child_idx(self: @Heap, idx: usize) -> usize;
}

impl HeapImpl of HeapTrait {
    #[inline(always)]
    fn new() -> Heap {
        let mut items = ArrayTrait::<felt>::new();
        Heap { items }
    }

    fn len(self: @Heap) -> usize {
        self.items.len()
    }

    fn is_empty(self: @Heap) -> bool {
        self.len() == ZERO_USIZE
    }

    fn add(ref self: Heap, value: felt) {
        let Heap{mut items} = self;
        items.append(value);
        let mut len = items.len();
        inner_add(ref items, len);
        self = Heap { items }
    }

    fn child_present(self: @Heap, idx: usize) -> bool {
        left_child_idx(idx) <= self.len()
    }

    fn right_child_idx(self: @Heap, idx: usize) -> usize {
        left_child_idx(idx) + 1_usize
    }

    fn smallest_child_idx(self: @Heap, idx: usize) -> usize {
        if self.right_child_idx(idx) > self.len() {
            left_child_idx(idx)
        } else {
            let ldx = left_child_idx(idx);
            let rdx = self.right_child_idx(idx);
            let l_item = self.items.at(ldx);
            let r_item = self.items.at(rdx);
            if *l_item > *r_item {
                ldx
            } else {
                rdx
            }
        }
    }
}

fn inner_add(ref items: Array::<felt>, idx: usize) {
    match gas::get_gas() {
        Option::Some(_) => {},
        Option::None(_) => {
            let mut data = ArrayTrait::new();
            data.append('OOG');
            panic(data);
        }
    }

    if idx == ZERO_USIZE {
        return ();
    }

    let pdx = parent_idx(idx);
    let idx_item = items.at(idx);
    let pdx_item = items.at(pdx);
    if *idx_item > *pdx_item {
        let mut swapped_items = array_swap(ref items, idx, pdx);

        items = swapped_items;
        return inner_add(ref items, pdx);
    } else {
        return inner_add(ref items, pdx);
    }
}

fn array_swap(ref src: Array::<felt>, a_idx: usize, b_idx: usize) -> Array::<felt> {
    let mut dst = array_new();
    let mut idx = 0_usize;
    fill_swap(ref dst, ref src, idx, a_idx, b_idx);
    dst
}

fn fill_swap(ref dst: Array::<felt>, ref src: Array::<felt>, idx: usize, a_idx: usize, b_idx: usize) {
    match gas::get_gas() {
        Option::Some(_) => {},
        Option::None(_) => {
            let mut data = ArrayTrait::new();
            data.append('OOG');
            panic(data);
        }
    }

    if idx == src.len() {
        return ();
    } else if idx == a_idx {
        let elem = src.at(b_idx);
        dst.append(*elem);
    } else if idx == b_idx {
        let elem = src.at(a_idx);
        dst.append(*elem);
    } else {
        let elem = src.at(idx);
        dst.append(*elem);
    }
    fill_swap(ref dst, ref src, idx + 1_usize, a_idx, b_idx)
}

fn parent_idx(idx: usize) -> usize {
    idx / 2_usize
}

fn left_child_idx(idx: usize) -> usize {
    idx * 2_usize
}