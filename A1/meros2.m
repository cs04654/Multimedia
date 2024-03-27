%load
pkg load signal
pkg load image
% Read the Cameraman image
f = imread('cameraman.tif');

% Convert to double for processing
f = double(f);

% Define quantization matrices
Q1 = [16 11 10 16 24 40 51 61;
      12 12 14 19 26 58 60 55;
      14 13 16 24 40 57 69 56;
      14 17 22 29 51 87 80 62;
      18 22 37 56 68 109 103 77;
      24 35 55 64 81 104 113 92;
      49 64 78 87 103 121 120 101;
      72 92 95 98 112 100 103 99];

Q2 = 3 * Q1;
Q3 = 6 * Q1;

% Divide the image into 8x8 blocks and process each block
[M, N] = size(f);
blockSize = 8;
numBlocksM = M / blockSize;
numBlocksN = N / blockSize;

entropyValues = zeros(3, 1); % To store entropy values for Q1, Q2, and Q3
zeroCoeffCount = zeros(3, 1); % To store the count of zeroed coefficients

for q = 1:3
    % Initialize matrices to store quantized and inverse quantized coefficients
    quantizedF = zeros(M, N);
    inverseQuantizedF = zeros(M, N);

    for i = 1:numBlocksM
        for j = 1:numBlocksN
            % Extract an 8x8 block
            block = f((i-1)*blockSize + 1 : i*blockSize, (j-1)*blockSize + 1 : j*blockSize);

            % Apply DCT to the block
            F = dct2(block);

            % Quantization
            quantizedF((i-1)*blockSize + 1 : i*blockSize, (j-1)*blockSize + 1 : j*blockSize) = round(F ./ eval(['Q', num2str(q)]));

            % Inverse quantization
            inverseQuantizedF((i-1)*blockSize + 1 : i*blockSize, (j-1)*blockSize + 1 : j*blockSize) = quantizedF((i-1)*blockSize + 1 : i*blockSize, (j-1)*blockSize + 1 : j*blockSize) .* eval(['Q', num2str(q)]);
        end
    end

    % Calculate entropy of the absolute value of quantized coefficients
    entropyValues(q) = entropy(abs(quantizedF));

    % Count the number of zeroed coefficients
    zeroCoeffCount(q) = sum(sum(quantizedF == 0));

    % Apply inverse DCT to each block
    inverseF = zeros(M, N);

    for i = 1:numBlocksM
        for j = 1:numBlocksN
            block = inverseQuantizedF((i-1)*blockSize + 1 : i*blockSize, (j-1)*blockSize + 1 : j*blockSize);
            inverseF((i-1)*blockSize + 1 : i*blockSize, (j-1)*blockSize + 1 : j*blockSize) = idct2(block);
        end
    end

    % Convert the image to uint8 and ensure values are within [0, 255]
    inverseF = uint8(inverseF);
    inverseF(inverseF < 0) = 0;
    inverseF(inverseF > 255) = 255;

    % Calculate PSNR
    mse = mean(mean((f - double(inverseF)).^2));
    psnr = 10 * log10(255^2 / mse);

    % Display and print the image
    figure;
    imagesc(inverseF);
    colormap(gray);
    title(['PSNR (dB) for Q', num2str(q), ' = ', num2str(psnr)]);
    print(['output_image_Q', num2str(q)], '-djpeg');

    disp(['For Q', num2str(q), ':']);
    disp(['Entropy of quantized coefficients: ', num2str(entropyValues(q))]);
    disp(['Number of zeroed coefficients: ', num2str(zeroCoeffCount(q))]);
    disp(['PSNR: ', num2str(psnr)]);
end
