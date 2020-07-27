#include <stdio.h>
#include <fcntl.h>
#include <stdlib.h>
#include <sys/mman.h>
#include <stdint.h>
#include <unistd.h>
#include <time.h>

#define MAP_SIZE 4096UL
#define MAP_MASK (MAP_SIZE -1)

#define DEV_BASE 0x43C00000


int main(int ac, char**av)
{
  printf("es geht los\n");

  int fd;
  uint32_t *ptr;

  if((fd = open("/dev/mem",O_RDWR | O_SYNC)) <0) {
    printf("Konnte /dev/mem/ nicht lesen\n");
    return 0;
  }

  printf("fd war okay\n");

  ptr = (uint32_t*) mmap(0, MAP_SIZE,PROT_READ | PROT_WRITE, MAP_SHARED, fd, DEV_BASE & ~MAP_MASK);
  printf("ptr = %x\n",ptr);


  //ptr[0] = //staffel_start
  //ptr[1] = //master_staffel_ende
  ptr[2] = 0xdeadbeef;//v0
  ptr[3] = 0x89abcdef;//v1
  //ptr[4] = //master_y_v0
  //ptr[5] = //master_y_v1
  ptr[6] = 0x00000000;//sum
  ptr[7] = 0x123456aa;//delta
  //ptr[8] = //master_y_sum
  ptr[9] = 0x1;//k0
  ptr[10] = 0x1;//k1
  ptr[11] = 0x1;//k2
  ptr[12] = 0x1;//k3

  printf("Setzen Staffel Start auf High\n");
  ptr[0] = 0x1;

  printf("Sleep 3sec\n");
  sleep(3);

  printf("master_staffel_ende: %x\n",ptr[1]);
  printf("y_v0: %x\n",ptr[4]);
  printf("y_v1: %x\n",ptr[5]);
  printf("y_sum: %x\n",ptr[8]);

  sleep(3);

  uint8_t offset = 13;
  printf("Vorbereiten Decrypt\n");
  //ptr[0] = //staffel_start
  //ptr[1] = //master_staffel_ende
  ptr[2+offset] = ptr[4];//v0
  ptr[3+offset] = ptr[5];//v1
  //ptr[4] = //master_y_v0
  //ptr[5] = //master_y_v1
  ptr[6+offset] = ptr[8];//sum
  ptr[7+offset] = 0x123456aa;//delta
  //ptr[8] = //master_y_sum
  ptr[9+offset] = 0x1;//k0
  ptr[10+offset] = 0x1;//k1
  ptr[11+offset] = 0x1;//k2
  ptr[12+offset] = 0x1;//k3

  printf("Decrypt startet jetzt\n");
  ptr[0+offset] = 0x1;

  sleep(3);
  printf("Decrypt ist fertig\n");

  printf("master_staffel_ende: %x\n",ptr[1]);
  printf("y_v0: %x\n",ptr[4]);
  printf("y_v1: %x\n",ptr[5]);
  printf("y_sum: %x\n",ptr[8]);

  printf("Exit\n");
  return 0;
}
