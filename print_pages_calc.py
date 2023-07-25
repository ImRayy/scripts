import typer
from rich.console import Console
from rich.theme import Theme

console = Console()
main = typer.Typer()

custom_colors = Theme(
    {
        "yellow": "bold yellow",
        "green": "bold green",
        "cyan": "bold cyan",
        "red": "bold red",
    }
)


def formula(a, b):
    odd = []
    even = []
    for x in range(a, (b + 1)):
        if x % 2 == 0:
            even.append(x)
        else:
            odd.append(x)
    return odd, even


def page_req_doublepage(oddlist, evenlist):
    if len(oddlist) > len(evenlist):
        if len(oddlist) % 2 != 0:
            a = int(len(oddlist) / 2) + 1
            return a
        else:
            return int((len(oddlist)) / 2)
    elif len(oddlist) < len(evenlist):
        if len(evenlist) % 2 != 0:
            a = int(len(evenlist) / 2) + 1
            return a
        else:
            return int((len(evenlist)) / 2)
    else:
        return int((len(oddlist)) / 2)


@main.command(short_help="Single content per page")
def singlepage(firstrange: int, lastrange: int):
    mainlist = formula(firstrange, lastrange)
    oddlist = mainlist[0]
    evenlist = mainlist[1]
    console.print("\n[yellow]Odd Pages[/yellow]", "[red]   ->[/red]", f"[yellow]{oddlist}[/yellow]\n")
    console.print("[green]Even Pages[/green]", " [red] ->[/red]", f"[green]{evenlist}[/green]\n")
    if len(oddlist) > len(evenlist):
        console.print("[#FF7373]Toral page required (bothside): [/#FF7373]", len(oddlist),"\n")
    elif len(oddlist) < len(evenlist):
        console.print("[#FF7373]Toral page required (bothside): [/#FF7373]", len(evenlist),"\n")
    else:
        console.print("[#FF7373]Toral page required (bothside): [/#FF7373]", len(oddlist),"\n")


@main.command(short_help="Double content per page")
def doublepage(firstrange: int, lastrange: int):
    odd = []
    even = []
    mainlist = formula(firstrange, lastrange)
    oddlist = mainlist[0]
    evenlist = mainlist[1]
    for i in range(len(oddlist)):

        if i % 2 == 0:
            odd.append(oddlist[i])
        else:
            even.append(oddlist[i])
    for i in range(len(evenlist)):

        if i % 2 == 0:
            odd.append(evenlist[i])
        else:
            even.append(evenlist[i])

    odd.sort()
    even.sort()
    console.print("\n[yellow]Odd Pages[/yellow]", "[red]  ->[/red]", f"[yellow]{odd}[/yellow]\n")
    console.print("[green]Even Pages[/green]", "[red] ->[/red]", f"[green]{even}[/green]\n")
    console.print("[#FF7373]Total page required (bothside): [/#FF7373]",page_req_doublepage(odd, even),"\n")

if __name__ == "__main__":
    main()
