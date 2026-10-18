" 単語途中の _ (snake_case、日本語_xxx など) を強調の開始とみなさず、色も付けない
syn clear markdownError
syn match markdownIntraword "[^[:space:][:punct:]]\@<=_\+" transparent contains=NONE
syn cluster markdownInline add=markdownIntraword
