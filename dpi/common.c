#include <unistd.h>
#include <stdint.h>
 
// ---------------------------------------------------------------------------
// Tabela de corner cases
// ---------------------------------------------------------------------------
static const uint16_t vectors[][2] = {
 
    // zeros & ones
    { 0x0000, 0x0000 },
    { 0x0000, 0xFFFF },
    { 0xFFFF, 0x0000 },
    { 0x0001, 0x0001 },
    { 0x0001, 0xFFFF },
    { 0xFFFF, 0x0001 },
 
    // unsigned max
    { 0xFFFF, 0xFFFF },
    { 0xFFFF, 0x0002 },
    { 0xFFFF, 0xFFFE },
 
    // signed extremes
    { 0x7FFF, 0x7FFF },   // SMAX * SMAX
    { 0x8000, 0x8000 },   // SMIN * SMIN
    { 0x8000, 0x7FFF },   // SMIN * SMAX
    { 0x8000, 0xFFFF },   // SMIN * -1  (signed)
    { 0x8001, 0x8001 },   // SMIN+1 * SMIN+1
 
    // potencias de 2
    { 0x0002, 0x0002 },
    { 0x0004, 0x0004 },
    { 0x0080, 0x0080 },
    { 0x0100, 0x0100 },
    { 0x8000, 0x0002 },
    { 0x8000, 0x8000 },   // MSB * MSB
 
    // padroes alternados
    { 0xAAAA, 0xAAAA },
    { 0x5555, 0x5555 },
    { 0xAAAA, 0x5555 },
    { 0x5555, 0xAAAA },
 
    // walking 1 (produto sempre = 0x8000)
    { 0x0001, 0x8000 },
    { 0x0002, 0x4000 },
    { 0x0004, 0x2000 },
    { 0x0008, 0x1000 },
    { 0x0010, 0x0800 },
    { 0x0020, 0x0400 },
    { 0x0040, 0x0200 },
    { 0x0080, 0x0100 },
 
    // near-boundary
    { 0x7FFE, 0x7FFE },
    { 0x8001, 0x7FFF },
 
    // comutatividade
    { 0x1234, 0x5678 },
    { 0x5678, 0x1234 },
    { 0xDEAD, 0xBEEF },
    { 0xBEEF, 0xDEAD },
 
};
 
#define NUM_VECTORS ((int)(sizeof(vectors) / sizeof(vectors[0])))
 
// ---------------------------------------------------------------------------
// Estado do iterador
// ---------------------------------------------------------------------------
static int current_idx = 0;
 
// Reseta o iterador para o inicio
void reset_vectors(void) {
    current_idx = 0;
}
 
// Retorna 1 e preenche *data1/*data2 com o proximo par.
// Retorna 0 quando acabaram os vetores.
int next_vector(uint16_t *data1, uint16_t *data2) {
    if (current_idx >= NUM_VECTORS)
        return 0;
 
    *data1 = vectors[current_idx][0];
    *data2 = vectors[current_idx][1];
    current_idx++;
    return 1;
}
 
// Quantidade total (util pro TB dimensionar o loop se quiser)
int get_num_vectors(void) {
    return NUM_VECTORS;
}

// Função de teste (scoreboard)
int multiplier(int in1, int in2)
{
    return in1 * in2;
}