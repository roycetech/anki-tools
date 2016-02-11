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
 * Another nice Object too.
 *
 * Can be used to avoid re-assignment in the client code.
 *
 * @author royce
 */
public class Ano2<T, U> extends Ano<T> {


    private transient U value2;


    public Ano2() {
        this(null, null);
    }

    public Ano2(final T defaultValue1, final U defaultValue2) {
        super(defaultValue1);
        value2 = defaultValue2;

    }


    public void set2(final U newValue) {
        value2 = newValue;
    }

    public U get2() {
        return value2;
    }


    @Override
    public String toString() {
        return super.toString() + ", " + value2 == null ? "null"
                : value2.toString();
    }

}
