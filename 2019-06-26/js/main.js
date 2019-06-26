const fs = require('fs');


const data = fs
    .readFileSync('dictionary.txt')
    .toString('utf-8')
    .split('\n');

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
}
