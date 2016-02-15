/**
 *   Copyright 2016 Royce Remulla
 *
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 */
package ph.rye.anki.util;

import java.lang.reflect.Array;

/**
 * @author royce
 */
public class Iter<T> {

    private final transient Iterable<T> iterable;
    private final transient T[] array;

    private transient int index;

    public Iter(final Iterable<T> iter) {
        assert iter != null;

        this.iterable = iter;
        this.array = null;
        index = 0;
    }

    @SuppressWarnings("unchecked")
    public Iter(final Class<T> klass, final T[] array) {
        assert array != null;

        this.iterable = null;
        this.array = (T[]) Array.newInstance(klass, array.length);
        System.arraycopy(array, 0, this.array, 0, array.length);
        index = 0;
    }


    public void each(final LoopBody<T> iterBody) {
        index = 0;
        if (iterable == null) {
            for (final T next : this.array) {
                iterBody.next(index, next);
                index++;
            }
        } else {
            for (final T next : iterable) {
                iterBody.next(index, next);
                index++;
            }
        }

    }

    public int getIndex() {
        return index;
    }

}
