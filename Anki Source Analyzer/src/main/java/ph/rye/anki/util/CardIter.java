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

import java.util.Iterator;

import ph.rye.anki.AnkiAppException;
import ph.rye.anki.model.Card;
import ph.rye.anki.model.CardModel;

/**
 * @author royce
 */
public class CardIter implements Iterator<Card> {


    private transient int counter;
    private transient int length;
    private transient CardModel model;


    public CardIter(final CardModel model) {
        assert model != null;

        this.model = model;
        length = model.getRowCount();

        counter = 0;
    }


    /** {@inheritDoc} */
    @Override
    public boolean hasNext() {
        return counter < length;
    }


    /** {@inheritDoc} */
    @Override
    public Card next() {
        if (counter >= length) {
            throw new AnkiAppException("Overflow!");
        } else {
            return model.getCardAt(counter++);
        }
    }

}
