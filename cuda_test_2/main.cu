#include <iostream>

const int N = 512; // Размер вектора

// CUDA ядро для сложения двух векторов
__global__ void vectorAdd(const float *A, const float *B, float *C)
{
    int index = threadIdx.x + blockIdx.x * blockDim.x;
    if (index < N)
    {
        C[index] = A[index] + B[index];
    }
}

int main()
{
    float A[N], B[N], C[N];

    // Инициализация данных
    for (int i = 0; i < N; i++)
    {
        A[i] = i;
        B[i] = i * 2;
    }

    float *d_A, *d_B, *d_C;

    // Выделение памяти на устройстве
    cudaMalloc((void **)&d_A, N * sizeof(float));
    cudaMalloc((void **)&d_B, N * sizeof(float));
    cudaMalloc((void **)&d_C, N * sizeof(float));

    // Копирование данных на устройство
    cudaMemcpy(d_A, A, N * sizeof(float), cudaMemcpyHostToDevice);
    cudaMemcpy(d_B, B, N * sizeof(float), cudaMemcpyHostToDevice);

    // Запуск ядра (1 блок, N потоков)
    vectorAdd<<<1, N>>>(d_A, d_B, d_C);

    // Копирование результата с устройства
    cudaMemcpy(C, d_C, N * sizeof(float), cudaMemcpyDeviceToHost);

    // Проверка результата
    for (int i = 0; i < N; i++)
    {
        if (C[i] != A[i] + B[i])
        {
            std::cerr << "error on pos " << i << ": " << C[i] << std::endl;
            return -1;
        }
    }

    std::cout << "good!" << std::endl;

    // Освобождение памяти
    cudaFree(d_A);
    cudaFree(d_B);
    cudaFree(d_C);

    return 0;
}