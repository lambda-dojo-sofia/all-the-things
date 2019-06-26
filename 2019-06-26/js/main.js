gconst fs = require('fs');


const dictionary = fs
      .readFileSync('dictionary.txt')
      .toString('utf-8')
      .split('\r\n');

function wordDistance(a, b) {
    // assumes that `a` and `b` are of the same length
    if (a.length === 0) {
	return 0;
    }
    const letterDistance = a.charCodeAt(0) !== b.charCodeAt(0);
    return letterDistance + wordDistance(a.substr(1), b.substr(1));
}

function findNeighbours(acc, dictionary) {
    const lastWord = acc[acc.length - 1];
    return dictionary
	.filter((x) => x.length === lastWord.length)
	.filter((x) => !acc.includes(x))
	.filter((x) => wordDistance(x, lastWord) === 1);
}

function wordChains(a, b) {
    function wordChainsHelper(acc) {
	const lastWord = acc[acc.length - 1];
	if (lastWord === b)
	    return acc
	for(const neighbour of findNeighbours(acc, dictionary)) {
	    const newAcc = wordChainsHelper([].concat(acc, neighbour));
	    if (newAcc) {
		return [].concat(acc, newAcc);
	    }
	    return false;
	}
    }

    return wordChainsHelper([a]);
}

exports.wordDistance = wordDistance;
exports.findNeighbours = findNeighbours;
exports.dictionary = dictionary;
exports.wordChains = wordChains;

console.log (wordChains ("leg", "cog"));