
declare -A XC

XC[red]=$'\e[1;31m'
XC[green]=$'\e[1;32m'
XC[yello]=$'\e[1;33m'
XC[blue]=$'\e[1;34m'
XC[magenta]=$'\e[1;35m'
XC[cyan]=$'\e[1;36m'
RS=$'\e[0m'


sed -e "/\(^ *->\)\|\(^ [^ ]\)/ {
                 s/Hash[^(]*\|Result\|BitmapAnd\|BitmapOr\|Limit/${XC[green]}&$RS/;
                 s/Split\|Partition Selector/${XC[green]}&$RS/;
                 s/[^>]* Scan/${XC[cyan]}&$RS/;
                 s/Insert\|Delete\|Update\|DML [^(]*\|Assert\|RowTrigger/${XC[cyan]}&$RS/;
                 s/\(Explicit *\)*Redistribute Motion\|Gather Motion/${XC[magenta]}&$RS/;
                 s/Broadcast Motion\|Append \|Window\|\<Aggregate\|GroupAggregate/${XC[yello]}&$RS/;
                 s/Repeat\|Sequence\|Merge [^(]*\|SetOp [^(]*/${XC[yello]}&$RS/;
                 s/Motion [^(]*\|Sort\|Unique\|Materialize\|Nested Loop [^(]*/${XC[red]}&$RS/;
                 s/Not-In/${XC[red]}&$RS/;
                 s/cost=[0-9]\{8,\}\.[0-9]*\.\.[0-9.]*/${XC[red]}&$RS/;
                 s/cost=[0-9]\{0,\}\.[0-9]*\.\.[0-9]\{8,\}\.[0-9]*/${XC[red]}&$RS/;
                 s/rows=[0-9]\{8,\}\>/${XC[red]}&$RS/;
                 s/cost=[[0-9]\{0,6\}\.[0-9]*\.\.[0-9]\{0,6\}.[0-9]* //;
                 s/ *rows=[0-9]\{0,5\}\>//;
                 s/ *width=[0-7]\?[0-9]\>//;
                 s/[(][)]//;
};
s/\<slice[0-9]*/${XC[blue]}&$RS/;
   
"
