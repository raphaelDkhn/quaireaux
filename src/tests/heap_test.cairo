use array::ArrayTrait;

use quaireaux::data_structures::heap::array_swap;
use quaireaux::data_structures::heap::HeapTrait;

#[test]
#[available_gas(2000000)]
fn test_array_swap() {
    let mut arr = array_new();
    arr.append(11);
    arr.append(12);
    arr.append(13);
    arr.append(14);

    let mut dst = array_swap(ref arr, 1_usize, 2_usize);
    assert(dst.len() == 4_usize, 'should still be of length 4');

    let idx1 = dst.at(1_usize);
    assert(*idx1 == 13, 'idx 1 should be 13 after swap');

    let idx2 = dst.at(2_usize);
    assert(*idx2 == 12, 'idx 2 should be 12 after swap');
}

#[test]
#[available_gas(2000000)]
fn test_heap() {
    let mut heap = HeapTrait::new();
    assert(heap.len() == 0_usize, 'heap should be empty');
    assert(heap.is_empty() == bool::True(()), 'heap should register empty');
    
    // heap.add(2);
    // heap.add(4);
    // heap.add(8);
    // assert(heap.len() == 3_usize, 'heap should have length');
    // assert(heap.next() == Option::None(()), 'next should be none');
}
