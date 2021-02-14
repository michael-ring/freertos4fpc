#!/bin/sh
FREERTOSDIR=FreeRTOS-LTS/FreeRTOS/FreeRTOS-Kernel/

mkdir -p lib/armv6m/default      2>/dev/null
mkdir -p lib/armv7m/default      2>/dev/null
mkdir -p lib/armv7em/eabihf     2>/dev/null
rm -f lib/armv6m/default/*.o     2>/dev/null
rm -f lib/armv6m/default/*.d     2>/dev/null
rm -f lib/armv6m/default/*.su    2>/dev/null
rm -f lib/armv7m/default/*.o     2>/dev/null
rm -f lib/armv7m/default/*.d     2>/dev/null
rm -f lib/armv7m/default/*.su    2>/dev/null
rm -f lib/armv7em/eabihf/*.o    2>/dev/null
rm -f lib/armv7em/eabihf/*.d    2>/dev/null
rm -f lib/armv7em/eabihf/*.su   2>/dev/null
rm -f lib/libfreertos.a 2>/dev/null
rm -f lib/libfreertos_heap_4.a 2>/dev/null
rm -f lib/libfreertos_heap_5.a 2>/dev/null

echo "Compiling FreeRTOS for armv6m"
cp FreeRTOSConfig.h.armv6m FreeRTOSConfig.h

FLAGS="-mcpu=cortex-m0plus -mfloat-abi=soft                   -mthumb -std=gnu11 -g3 -DDEBUG -c \
       -I. -I$FREERTOSDIR/include -O2 -I$FREERTOSDIR/portable/GCC/ARM_CM0  -ffunction-sections -fdata-sections -Wall -fstack-usage -MMD -MP --specs=nano.specs"
arm-none-eabi-gcc "$FREERTOSDIR/tasks.c" $FLAGS -E | grep -f freertos-defines.h | sed -e "s,(,,g" -e "s,),,g" -e "s,uint16_t,,g" -e "s,TickType_t,,g" -e "s,size_t,,g" -e "s,[ ][ ]*, ,g" -e "s,[ ][ ]*$,,g" -e "s,#define ,{\$define,g" -e "s,$,},g" -e "s, , := ,g" -e "s,{\$define,{\$define ,g" -e "s,_STACK_,__STACK_,g" >FreeRTOSConfig-armv6m.inc
echo "{\$define tskSTATIC_AND_DYNAMIC_ALLOCATION_POSSIBLE := 1}" >>FreeRTOSConfig-armv6m.inc
arm-none-eabi-gcc "$FREERTOSDIR/portable/MemMang/heap_4.c"    $FLAGS -o lib/armv6m/default/heap_4.o
arm-none-eabi-gcc "$FREERTOSDIR/portable/MemMang/heap_5.c"    $FLAGS -o lib/armv6m/default/heap_5.o
arm-none-eabi-gcc "$FREERTOSDIR/portable/GCC/ARM_CM0/port.c"  $FLAGS -o lib/armv6m/default/port.o
arm-none-eabi-gcc "$FREERTOSDIR/event_groups.c"               $FLAGS -o lib/armv6m/default/event_groups.o
arm-none-eabi-gcc "$FREERTOSDIR/list.c"                       $FLAGS -o lib/armv6m/default/list.o
arm-none-eabi-gcc "$FREERTOSDIR/queue.c"                      $FLAGS -o lib/armv6m/default/queue.o
arm-none-eabi-gcc "$FREERTOSDIR/stream_buffer.c"              $FLAGS -o lib/armv6m/default/stream_buffer.o
arm-none-eabi-gcc "$FREERTOSDIR/tasks.c"                      $FLAGS -o lib/armv6m/default/tasks.o
arm-none-eabi-gcc "$FREERTOSDIR/timers.c"                     $FLAGS -o lib/armv6m/default/timers.o
arm-none-eabi-ar rcs lib/armv6m/default/libfreertos.a lib/armv6m/default/port.o lib/armv6m/default/event_groups.o lib/armv6m/default/list.o lib/armv6m/default/queue.o lib/armv6m/default/stream_buffer.o lib/armv6m/default/tasks.o lib/armv6m/default/timers.o
arm-none-eabi-ar rcs lib/armv6m/default/libfreertos_heap_4.a lib/armv6m/default/heap_4.o
arm-none-eabi-ar rcs lib/armv6m/default/libfreertos_heap_5.a lib/armv6m/default/heap_5.o

echo "Compiling FreeRTOS for armv7m"
cp FreeRTOSConfig.h.armv7m FreeRTOSConfig.h
FLAGS="-mcpu=cortex-m3     -mfloat-abi=soft                   -mthumb -std=gnu11 -g3 -DDEBUG -c \
       -I. -I$FREERTOSDIR/include -O2 -I$FREERTOSDIR/portable/GCC/ARM_CM3  -ffunction-sections -fdata-sections -Wall -fstack-usage -MMD -MP --specs=nano.specs"

arm-none-eabi-gcc "$FREERTOSDIR/tasks.c" $FLAGS -E | grep -f freertos-defines.h | sed -e "s,(,,g" -e "s,),,g" -e "s,uint16_t,,g" -e "s,TickType_t,,g" -e "s,size_t,,g" -e "s,[ ][ ]*, ,g" -e "s,[ ][ ]*$,,g" -e "s,#define ,{\$define,g" -e "s,$,},g" -e "s, , := ,g" -e "s,{\$define,{\$define ,g" -e "s,_STACK_,__STACK_,g" >FreeRTOSConfig-armv7m.inc
echo "{\$define tskSTATIC_AND_DYNAMIC_ALLOCATION_POSSIBLE := 1}" >>FreeRTOSConfig-armv7m.inc

arm-none-eabi-gcc "$FREERTOSDIR/portable/MemMang/heap_4.c"    $FLAGS -o lib/armv7m/default/heap_4.o
arm-none-eabi-gcc "$FREERTOSDIR/portable/MemMang/heap_5.c"    $FLAGS -o lib/armv7m/default/heap_5.o
arm-none-eabi-gcc "$FREERTOSDIR/portable/GCC/ARM_CM3/port.c"  $FLAGS -o lib/armv7m/default/port.o
arm-none-eabi-gcc "$FREERTOSDIR/event_groups.c"               $FLAGS -o lib/armv7m/default/event_groups.o
arm-none-eabi-gcc "$FREERTOSDIR/list.c"                       $FLAGS -o lib/armv7m/default/list.o
arm-none-eabi-gcc "$FREERTOSDIR/queue.c"                      $FLAGS -o lib/armv7m/default/queue.o
arm-none-eabi-gcc "$FREERTOSDIR/stream_buffer.c"              $FLAGS -o lib/armv7m/default/stream_buffer.o
arm-none-eabi-gcc "$FREERTOSDIR/tasks.c"                      $FLAGS -o lib/armv7m/default/tasks.o
arm-none-eabi-gcc "$FREERTOSDIR/timers.c"                     $FLAGS -o lib/armv7m/default/timers.o
arm-none-eabi-ar rcs lib/armv7m/default/libfreertos.a lib/armv7m/default/port.o lib/armv7m/default/event_groups.o lib/armv7m/default/list.o lib/armv7m/default/queue.o lib/armv7m/default/stream_buffer.o lib/armv7m/default/tasks.o lib/armv7m/default/timers.o
arm-none-eabi-ar rcs lib/armv7m/default/libfreertos_heap_4.a lib/armv7m/default/heap_4.o
arm-none-eabi-ar rcs lib/armv7m/default/libfreertos_heap_5.a lib/armv7m/default/heap_5.o

echo "Compiling FreeRTOS for armv7em nvic_prio_bits_3"
cp FreeRTOSConfig.h.armv7em.priobits3 FreeRTOSConfig.h
FLAGS="-mcpu=cortex-m4     -mfpu=fpv4-sp-d16 -mfloat-abi=hard -mthumb -std=gnu11 -g3 -DDEBUG -c \
       -I. -I$FREERTOSDIR/include -O2 -I$FREERTOSDIR/portable/GCC/ARM_CM4F -ffunction-sections -fdata-sections -Wall -fstack-usage -MMD -MP --specs=nano.specs"
arm-none-eabi-gcc "$FREERTOSDIR/tasks.c" $FLAGS -E | grep -f freertos-defines.h | sed -e "s,(,,g" -e "s,),,g" -e "s,uint16_t,,g" -e "s,TickType_t,,g" -e "s,size_t,,g" -e "s,[ ][ ]*, ,g" -e "s,[ ][ ]*$,,g" -e "s,#define ,{\$define,g" -e "s,$,},g" -e "s, , := ,g" -e "s,{\$define,{\$define ,g" -e "s,_STACK_,__STACK_,g" >FreeRTOSConfig-armv7em.inc
echo "{\$define tskSTATIC_AND_DYNAMIC_ALLOCATION_POSSIBLE := 1}" >>FreeRTOSConfig-armv7em.inc

arm-none-eabi-gcc "$FREERTOSDIR/portable/GCC/ARM_CM4F/port.c" $FLAGS -o lib/armv7em/eabihf/port.o
arm-none-eabi-gcc "$FREERTOSDIR/event_groups.c"               $FLAGS -o lib/armv7em/eabihf/event_groups.o
arm-none-eabi-gcc "$FREERTOSDIR/list.c"                       $FLAGS -o lib/armv7em/eabihf/list.o
arm-none-eabi-gcc "$FREERTOSDIR/queue.c"                      $FLAGS -o lib/armv7em/eabihf/queue.o
arm-none-eabi-gcc "$FREERTOSDIR/stream_buffer.c"              $FLAGS -o lib/armv7em/eabihf/stream_buffer.o
arm-none-eabi-gcc "$FREERTOSDIR/tasks.c"                      $FLAGS -o lib/armv7em/eabihf/tasks.o
arm-none-eabi-gcc "$FREERTOSDIR/timers.c"                     $FLAGS -o lib/armv7em/eabihf/timers.o
arm-none-eabi-ar rcs lib/armv7em/eabihf/libfreertos_priobits3.a lib/armv7em/eabihf/port.o lib/armv7em/eabihf/event_groups.o lib/armv7em/eabihf/list.o lib/armv7em/eabihf/queue.o lib/armv7em/eabihf/stream_buffer.o lib/armv7em/eabihf/tasks.o lib/armv7em/eabihf/timers.o

echo "Compiling FreeRTOS for armv7em nvic_prio_bits_4"
cp FreeRTOSConfig.h.armv7em.priobits4 FreeRTOSConfig.h
FLAGS="-mcpu=cortex-m4     -mfpu=fpv4-sp-d16 -mfloat-abi=hard -mthumb -std=gnu11 -g3 -DDEBUG -c \
       -I. -I$FREERTOSDIR/include -O2 -I$FREERTOSDIR/portable/GCC/ARM_CM4F -ffunction-sections -fdata-sections -Wall -fstack-usage -MMD -MP --specs=nano.specs"
arm-none-eabi-gcc "$FREERTOSDIR/tasks.c" $FLAGS -E | grep -f freertos-defines.h | sed -e "s,(,,g" -e "s,),,g" -e "s,uint16_t,,g" -e "s,TickType_t,,g" -e "s,size_t,,g" -e "s,[ ][ ]*, ,g" -e "s,[ ][ ]*$,,g" -e "s,#define ,{\$define,g" -e "s,$,},g" -e "s, , := ,g" -e "s,{\$define,{\$define ,g" -e "s,_STACK_,__STACK_,g" >FreeRTOSConfig-armv7em.inc
echo "{\$define tskSTATIC_AND_DYNAMIC_ALLOCATION_POSSIBLE := 1}" >>FreeRTOSConfig-armv7em.inc

arm-none-eabi-gcc "$FREERTOSDIR/portable/MemMang/heap_4.c"    $FLAGS -o lib/armv7em/eabihf/heap_4.o
arm-none-eabi-gcc "$FREERTOSDIR/portable/MemMang/heap_5.c"    $FLAGS -o lib/armv7em/eabihf/heap_5.o
arm-none-eabi-gcc "$FREERTOSDIR/portable/GCC/ARM_CM4F/port.c" $FLAGS -o lib/armv7em/eabihf/port.o
arm-none-eabi-gcc "$FREERTOSDIR/event_groups.c"               $FLAGS -o lib/armv7em/eabihf/event_groups.o
arm-none-eabi-gcc "$FREERTOSDIR/list.c"                       $FLAGS -o lib/armv7em/eabihf/list.o
arm-none-eabi-gcc "$FREERTOSDIR/queue.c"                      $FLAGS -o lib/armv7em/eabihf/queue.o
arm-none-eabi-gcc "$FREERTOSDIR/stream_buffer.c"              $FLAGS -o lib/armv7em/eabihf/stream_buffer.o
arm-none-eabi-gcc "$FREERTOSDIR/tasks.c"                      $FLAGS -o lib/armv7em/eabihf/tasks.o
arm-none-eabi-gcc "$FREERTOSDIR/timers.c"                     $FLAGS -o lib/armv7em/eabihf/timers.o
arm-none-eabi-ar rcs lib/armv7em/eabihf/libfreertos_priobits4.a lib/armv7em/eabihf/port.o lib/armv7em/eabihf/event_groups.o lib/armv7em/eabihf/list.o lib/armv7em/eabihf/queue.o lib/armv7em/eabihf/stream_buffer.o lib/armv7em/eabihf/tasks.o lib/armv7em/eabihf/timers.o
arm-none-eabi-ar rcs lib/armv7em/eabihf/libfreertos_heap_4.a lib/armv7em/eabihf/heap_4.o
arm-none-eabi-ar rcs lib/armv7em/eabihf/libfreertos_heap_5.a lib/armv7em/eabihf/heap_5.o

LIBCBASE="$(arm-none-eabi-gcc -print-sysroot)/lib"
LIBCARMV6M="$(arm-none-eabi-gcc -print-multi-lib | grep v6-m | awk -F\; '{print $1}')"
if [ -f "$LIBCBASE/$LIBCARMV6M/libc_nano.a" ]; then 
  cp "$LIBCBASE/$LIBCARMV6M/libc_nano.a" lib/armv6m/default/
else
  echo "Could not find libc_nano.a for armv6m, please copy manually to lib/armv6m/default/"
  exit 1
fi
LIBCARMV7M="$(arm-none-eabi-gcc -print-multi-lib | grep v7-m | awk -F\; '{print $1}')"
if [ -f "$LIBCBASE/$LIBCARMV7M/libc_nano.a" ]; then 
  cp "$LIBCBASE/$LIBCARMV7M/libc_nano.a" lib/armv7m/default/
else
  echo "Could not find libc_nano.a for armv7m, please copy manually to lib/armv7m/default/"
  exit 1
fi
LIBCARMV7EM="$(arm-none-eabi-gcc -print-multi-lib | grep v7e-m | grep "fpv4-sp/hard" | awk -F\; '{print $1}')"
if [ -f "$LIBCBASE/$LIBCARMV7EM/libc_nano.a" ]; then 
  cp "$LIBCBASE/$LIBCARMV7EM/libc_nano.a" lib/armv7em/eabihf/
else
  echo "Could not find libc_nano.a for armv6m, please copy manually to lib/armv7em/eabihf/"
  exit 1
fi

rm -f FreeRTOSConfig.h
rm -f tasks.d
for dir in armv6m/default armv7m/default armv7em/eabihf ; do
  rm -f lib/$dir/*.d 2>/dev/null
  rm -f lib/$dir/*.o 2>/dev/null
  rm -f lib/$dir/*.su 2>/dev/null
done

rm -f FreeRTOS-10.4.3-for-for-FreePascal.zip 2>/dev/null
zip -r FreeRTOS-10.4.3-for-for-FreePascal.zip lib
