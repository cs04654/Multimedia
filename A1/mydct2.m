function F = mydct2(f)
    [rows, cols] = size(f);
    F = zeros(rows, cols);
    
    % Apply 1D DCT to each row
    for i = 1:rows
        F(i, :) = mydct(f(i, :));
    end
    
    % Apply 1D DCT to each column
    for j = 1:cols
        F(:, j) = mydct(F(:, j));
    end
end