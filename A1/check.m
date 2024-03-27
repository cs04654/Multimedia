%load
pkg load signal
pkg load image
% Create an 8x8 matrix (sample data)
matrix = rand(8, 8);

% Calculate DCT using mydct2
my_dct_result = mydct2(matrix);

% Calculate DCT using the built-in dct2 function
dct2_result = dct2(matrix);

% Calculate the absolute difference between the two results
difference = abs(my_dct_result - dct2_result);

% Display the maximum absolute difference
max_difference = max(difference(:));

if max_difference < 1e-10
    disp('Results match. Maximum absolute difference is very close to zero.');
else
    disp('Results do not match. Maximum absolute difference is not zero.');
end
