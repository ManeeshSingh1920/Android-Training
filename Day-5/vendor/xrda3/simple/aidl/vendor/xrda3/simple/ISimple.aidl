// FIXME: license file, or use the -l option to generate the files with the header.

package vendor.xrda3.simple;

/**
 * Very small HIDL demo for training.
 * Just adds two numbers.
 */
@VintfStability
interface ISimple {
    // Adding return type to method instead of out param int result since there is only one return value.
    /**
     * Adds two 32-bit integers and returns the result.
     */
    int add(in int a, in int b);
}
