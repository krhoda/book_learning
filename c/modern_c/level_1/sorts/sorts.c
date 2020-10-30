#include <stdio.h>
#include <stdlib.h>

void quicksort(int number[25], int first, int last)
{
    int i, j, pivot, temp;

    // first will be 0.
    // last will be the last valid index.
    // thus, if last > 0, the sort will occur
    if (first < last)
    {
        // set both the pivot and the initial to first.
        pivot = first;
        i = first;
        // set j to the top most index.
        j = last;

        while (i < j)
        {
            // iterate from the beginning of the list until a number
            // larger than the pivot is hit. Break before flying off
            // the end of the list.
            while (number[i] <= number[pivot] && i < last)
            {
                i++;
            }

            // traverse the list from the end towards the front,
            // breaking when a number smaller than the pivot is hit.
            while (number[j] > number[pivot])
            {
                j--;
            }

            // if the position of the first number larger than the
            // pivot is earlier than the last number smaller than
            // the pivot...
            if (i < j)
            {
                // hold the value at i.
                temp = number[i];
                // place the value at j at the postion of i.
                number[i] = number[j];
                // place the value that was at i at j.
                number[j] = temp;
            }
        }

        // hold the value of the pivot.
        temp = number[pivot];
        // set the pivot to the value of swapped larger value
        number[pivot] = number[j];
        // set the swapped larger value to the pivot.
        number[j] = temp;

        // recursively sort the front of the array
        quicksort(number, first, j - 1);
        // recursively sort the back of the array
        quicksort(number, j + 1, last);
    }
}

void mergesort(int first, int last, int number[], int aux[])
{
    if (last <= first)
    {
        // The section is either empty or singleton
        return;
    }

    // This seems to implicitly round.
    int mid = (first + last) / 2;
    // left will be number[first .. mid]
    // right will be number[mid + 1 .. j]

    mergesort(first, mid, number, aux);
    mergesort(mid + 1, last, number, aux);

    int p_left = first;
    int p_right = mid + 1;

    // iterate from start to end to fill the array
    for (int index = first; index <= last; index++)
    {
        if (p_left == mid + 1)
        {
            // If the left pointer has hit the limit...
            // set the value at the index to value of
            // the right pointer.
            aux[index] = number[p_right];
            // increment the right pointer
            p_right++;
        }
        else if (p_right == last + 1)
        {
            // If the right pointer ha hit the limit...
            // set the value at the index to value of
            // the left pointer.
            aux[index] = number[p_left];
            p_left++;
        }
        else if (number[p_left] < number[p_right])
        {
            // if p_left points to the smaller element,
            // set the index to the number it points to.
            aux[index] = number[p_left];
            p_left++;
        }
        else
        {
            // p_right points to the smaller element
            aux[index] = number[p_right];
            p_right++;
        }
    }

    for (int index2 = first; index2 <= last; index2++)
    {
        // set all elements in number to the auxiliry values
        number[index2] = aux[index2];
    }
}

int main()
{
    int qs[10] = {8, 5, 10, 6, 37, 22, 45, 4, 6, 99};

    quicksort(qs, 0, 9);

    int failed = 0;
    for (int i = 0; i < 10; i++)
    {
        printf("Element[%d] = %d\n", i, qs[i]);
        // skip the first iteration
        if (i != 0)
        {
            if (qs[i] < qs[i - 1])
            {
                failed = 1;
                break;
            }
        }
    }

    if (failed)
    {
        puts("QUICKSORT FAILED");
        return 1;
    }
    else
    {
        puts("QUICKSORT SUCCEEDED");
    }

    int m[10] = {8, 5, 10, 6, 37, 22, 45, 4, 6, 99};
    int aux[10];

    mergesort(0, 9, m, aux);
    for (int i = 0; i < 10; i++)
    {
        printf("Element[%d] = %d\n", i, m[i]);
        // skip the first iteration
        if (i != 0)
        {
            if (m[i] < m[i - 1])
            {
                failed = 1;
            }
        }
    }

    if (failed)
    {
        puts("MERGESORT FAILED");
        return 1;
    }
    else
    {
        puts("MERGESORT SUCCEEDED");
    }
    return EXIT_SUCCESS;
}