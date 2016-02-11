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

/**
 * @author royce
 *
 */
public class Range<T> {

    private final transient int start;
    private final transient int end;

    public Range(final int start, final int end) {
        this.start = start;
        this.end = end;
    }

    @SuppressWarnings("unchecked")
    public void each(final LoopBody<T> rangeBody) {
        for (int i = start; i < end; i++) {
            rangeBody.next((T) (Integer) i);
        }
    }

}
