addCopyright();
expandNavigation();

function addCopyright() {
    let year = new Date().getFullYear();

    let copyrightElement = document.getElementsByClassName("md-copyright")[0];
    copyrightElement.innerHTML = "";

    let copyrightText = document.createElement("span");
    copyrightText.innerHTML = "Copyright &copy; " + year;
    copyrightElement.appendChild(copyrightText);

    let space = document.createElement("span");
    space.innerHTML = " ";
    copyrightElement.appendChild(space);

    let companyLink = document.createElement("a");
    companyLink.href = "https://labymod.net";
    companyLink.innerHTML = "LabyMedia GmbH";
    copyrightElement.appendChild(companyLink);

    let space2 = document.createElement("span");
    space2.innerHTML = " - ";
    copyrightElement.appendChild(space2);

    let imprintLink = document.createElement("a");
    imprintLink.href = "https://labymod.net/impressum";
    imprintLink.innerHTML = "Imprint";
    copyrightElement.appendChild(imprintLink);
}

function expandNavigation() {
    document.addEventListener("DOMContentLoaded", function () {
        let nav = document.getElementsByClassName("md-nav");
        for (let i = 0; i < nav.length; i++) {
            if (nav.item(i).getAttribute("data-md-level")) {
                nav.item(i).style.display = 'block';
                nav.item(i).style.overflow = 'visible';
            }
        }

        nav = document.getElementsByClassName("md-nav__toggle");
        for (let i = 0; i < nav.length; i++) {
            nav.item(i).checked = true;
        }
    });
}