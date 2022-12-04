const BEERS = {};

const handleResponse = (beers) => {
  BEERS.list = beers;
  BEERS.show();
};

const createTableRow = (beer) => {
  const tr = document.createElement("tr");
  tr.classList.add("tablerow");
  const beername = tr.appendChild(document.createElement("td"));
  beername.innerHTML = beer.name;
  const style = tr.appendChild(document.createElement("td"));
  style.innerHTML = beer.style.name;
  const brewery = tr.appendChild(document.createElement("td"));
  brewery.innerHTML = beer.brewery.name;

  return tr;
};

BEERS.show = () => {
  document.querySelectorAll(".tablerow").forEach((el) => el.remove());
  const table = document.getElementById("beertable");

  BEERS.list.forEach((beer) => {
    const tr = createTableRow(beer);
    table.appendChild(tr);
  });
};

BEERS.sortByName = () => {
  BEERS.list.sort((a, b) => {
    return a.name.toUpperCase().localeCompare(b.name.toUpperCase());
  });
};

BEERS.sortByStyle = () => {
  BEERS.list.sort((a, b) => {
    return a.style.name.toUpperCase().localeCompare(b.style.name.toUpperCase());
  });
};

BEERS.sortByBrewery = () => {
  BEERS.list.sort((a, b) => {
    return a.brewery.name
      .toUpperCase()
      .localeCompare(b.brewery.name.toUpperCase());
  });
};

const beers = () => {

  if (document.querySelectorAll("#beertable").length < 1) return;

  document.getElementById("name").addEventListener("click", (e) => {
    e.preventDefault;
    BEERS.sortByName();
    BEERS.show();
  });

  document.getElementById("style").addEventListener("click", (e) => {
    e.preventDefault;
    BEERS.sortByStyle();
    BEERS.show();
  });

  document.getElementById("brewery").addEventListener("click", (e) => {
    e.preventDefault;
    BEERS.sortByBrewery();
    BEERS.show();
  });

  fetch("beers.json")
    .then((response) => response.json())
    .then(handleResponse);
};

/* Brewery */

const createElement = (tag,innerHTML) => {
	const elem = document.createElement(tag)
	if (innerHTML) {
		elem.innerHTML = innerHTML
	}
	return(elem)
}

const BREWERIES = {}

BREWERIES.sortByName = () => {
	BREWERIES.list.sort((a, b) => {
		return a.name.toUpperCase().localeCompare(b.name.toUpperCase());
	});
}

BREWERIES.sortByYear = () => {
	BREWERIES.list.sort((a, b) => {
		return a.year - b.year;
	});
}
BREWERIES.sortByBeerCount = () => {
	BREWERIES.list.sort((a, b) => {
		return a.beercount - b.beercount;
	});
}


BREWERIES.createHeader = () => {
	
	const theader   = createElement("thead");
	BREWERIES.table.appendChild(theader)

	const headerRow = createElement("tr");
	theader.appendChild(headerRow)

	const headers = [
		{ text: "Name", 			onclick: (e) => {  e.preventDefault; BREWERIES.sortByName(); BREWERIES.show();  } },
		{ text: "Founded", 			onclick: (e) => {  e.preventDefault; BREWERIES.sortByYear(); BREWERIES.show();  } },
		{ text: "Active" },
		{ text: "Beers manufactured", onclick: (e) => {  e.preventDefault; BREWERIES.sortByBeerCount(); BREWERIES.show();  } }
	];

	let headerElement;
	for (let header of headers) {
		headerElement = createElement("th", header.text);
		headerElement.addEventListener('click', header.onclick)
		headerRow.appendChild(headerElement)
	}

}

const makeRowOfBrewery = brewery => {
	const row = createElement("tr");
	const values = ["name", "year", "active", "beercount"];

	values.forEach(val => {
		row.appendChild(
			createElement("td", brewery[val])
		);
	})
	return(row)
}

BREWERIES.clear = () => {
	const toRemove = Array(...BREWERIES.table.childNodes);
	toRemove.forEach((elem) => { elem.remove(); });
}

BREWERIES.show = () => {
	// Clear table
	BREWERIES.clear();

	// Add table headers
	BREWERIES.createHeader();

	// Table body
	const tbody   = createElement("tbody");
	BREWERIES.table.appendChild(tbody)
	
	for (let brewery of BREWERIES.list) {	
		tbody.append(makeRowOfBrewery(brewery))
	}
}

const handleBreweriesResponse = breweries => {
	// Count number of beers in breweries and store to object
	BREWERIES.list = breweries.map(brew => ({ beercount: brew.beers.length, ...brew  }))

	// Display breweries
	BREWERIES.show(breweries)
}



const listBreweries = () => {

  if (document.querySelectorAll("#brewerylist").length < 1) return;

  BREWERIES.table = document.getElementById("brewerylist")

  fetch("breweries.json")
    .then((response) => response.json())
    .then(handleBreweriesResponse);

}

export { beers, listBreweries };