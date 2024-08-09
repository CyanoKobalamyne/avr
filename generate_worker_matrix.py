#!/bin/env python3
"""Generate workers file with all flag combinations."""


def main():

    # BMC and k-induction
    for engine in ("bmc", "kind"):
        for abstraction in ("sa+uf", "sa"):
            for split_arg in ("", " --split"):
                print(f"avr.py --{engine} --abstract {abstraction}{split_arg}")

    # IC3SA
    for abstraction in ("sa+uf", "sa", "sa4", "sa8", "sa16", "sa32"):
        for interpol in range(2):
            for forward in range(2):
                for level in (0, 2, 5):
                    for split_arg in ("", " --split"):
                        print(
                            f"avr.py --abstract {abstraction} --interpol"
                            f" {interpol} --forward {forward} --level"
                            f" {level}{split_arg}"
                        )


if __name__ == "__main__":
    main()
