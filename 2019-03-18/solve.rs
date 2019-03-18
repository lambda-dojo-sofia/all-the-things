type Board = [[i8; 5]; 5];

fn main() {
    let board: Board = [
        [7, 5, 2, 3, 1],
        [3, 4, 1, 4, 4],
        [1, 5, 6, 7, 8],
        [3, 4, 5, 8, 9],
        [3, 2, 2, 7, 6],
    ];

    println!("{:?}", longest_sequence(board));
}

fn longest_sequence(board: Board) -> Vec<i8> {
    let mut best_seq: Vec<i8> = Vec::new();
    for y in 0usize..board.len() {
        for x in 0usize..board[y].len() {
            let my_seq = longest_sequence_from_point(board, y, x, Vec::new());
            if my_seq.len() > best_seq.len() {
                best_seq = my_seq;
            }
        }
    }
    return best_seq;
}

fn longest_sequence_from_point(board: Board, y: usize, x: usize, acc: Vec<i8>) -> Vec<i8> {
    let mut copy_acc = acc.to_vec();
    copy_acc.push(board[y][x]);
    let mut best_seq: Vec<i8> = copy_acc.to_vec();
    if y < 4 && (board[y][x] - board[y+1][x]).abs() == 1 { 
        let my_seq = longest_sequence_from_point(board, y+1, x, copy_acc.to_vec());
        if my_seq.len() > best_seq.len() {
            best_seq = my_seq;
        }
    }
    if x < 4 && (board[y][x] - board[y][x+1]).abs() == 1 { 
        let my_seq = longest_sequence_from_point(board, y, x+1, copy_acc.to_vec());
        if my_seq.len() > best_seq.len() {
            best_seq = my_seq;
        }
    }
    return best_seq;
}
