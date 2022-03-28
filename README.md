# Cowsay.vim

Cowsay in Vim.
This works well with my [fortune.vim](https://github.com/iwataka/fortune.vim) and [vim-startify](https://github.com/mhinz/vim-startify).

## Functions

+ cowsay#cowsay(lines, animal)

    Specified animal will say the sentence (given lines).
    Go [here](https://github.com/schacon/cowsay/tree/master/cows) to check the list of available animals.

    If you want to add more animals, you can add custom cowsay file patterns to g:cowsay_file_glob_patterns like below.

    ```vim
    " after loading cowsay.vim
    let g:cowsay_file_glob_patterns = ['/path/to/somewhere/*.cow'] + g:cowsay_file_glob_patterns
    ```

## Credit

Thanks to the below programs:

+ [tnalpgge/rank-amateur-cowsay](https://github.com/tnalpgge/rank-amateur-cowsay)
