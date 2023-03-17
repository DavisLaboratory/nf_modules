# NF Modules

Nextflow modules for use in data processing pipelines


## How to use

- Clone this repo to a suitable location (e.g., a lab-share)
- within your `params.config` file for a nextflow pipeline add the following line

```
 module_dir = "/path/to/nf_modules"   
```

- Import modules within main.nf as follows

```nextflow
include {MY_MODULE} from "${params.module_dir}/my_module"
```


## Adding a new module

- Create a new branch for the new module

```bash
git branch <module-name>
git checkout <module-name>

cp -r template <module-name>
```

- Write ya code
- Test yer code
- Write a pull request (get someone else to review)
- $$$


## Acknowledgements

Module structure inspired by the nf-core project 

> **The nf-core framework for community-curated bioinformatics pipelines.**
>
> Philip Ewels, Alexander Peltzer, Sven Fillinger, Harshil Patel, Johannes Alneberg, Andreas Wilm, Maxime Ulysse Garcia, Paolo Di Tommaso & Sven Nahnsen.
>
> _Nat Biotechnol._ 2020 Feb 13. doi: [10.1038/s41587-020-0439-x](https://dx.doi.org/10.1038/s41587-020-0439-x).
