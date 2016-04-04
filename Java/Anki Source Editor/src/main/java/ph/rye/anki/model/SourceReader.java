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
package ph.rye.anki.model;


import java.io.BufferedReader;
import java.io.IOException;
import java.io.Reader;
import java.util.Arrays;
import java.util.LinkedHashSet;
import java.util.Set;
import java.util.logging.Level;
import java.util.logging.Logger;

import ph.rye.anki.AnkiMainGui;
import ph.rye.anki.util.Action;
import ph.rye.anki.util.Counter;
import ph.rye.common.lang.Ano;
import ph.rye.common.lang.StringUtil;

/**
 * @author royce
 *
 */
class SourceReader {


    private static final String TAGS_MARKER = "@Tags: ";


    private final transient Reader reader;


    SourceReader(final Reader reader) {
        this.reader = reader;
    }


    @SuppressWarnings("unchecked")
    public void readSource(final Action<Card> action) {
        try (final BufferedReader buffReader = new BufferedReader(reader)) {

            final Counter spaceCounter = new Counter(0);

            final Ano<Boolean> cardStart = new Ano<>(false);
            final AbstractArrayedBuffReader<Object> aabr =
                    new AbstractArrayedBuffReader<Object>(
                        buffReader,
                        new LinkedHashSet<String>(),
                        new LinkedHashSet<String>(),
                        new LinkedHashSet<String>(),
                        new Ano<Boolean>(false)) {

                        @Override
                        public void next(final String line) {

                            if (!cardStart.get() && (line.startsWith("#")
                                    || "".equals(line))) {
                                return;
                            } else {
                                cardStart.set(true);
                            }

                            if ("".equals(line.trim())) {
                                spaceCounter.inc();
                            } else {

                                final Ano<Boolean> isAnswer =
                                        (Ano<Boolean>) get(3);

                                if (spaceCounter.get() >= 2) {
                                    final Set<String> front =
                                            (Set<String>) get(0);
                                    final Set<String> back =
                                            (Set<String>) get(1);
                                    final Set<String> tags =
                                            (Set<String>) get(2);

                                    isAnswer.set(false);

                                    action.execute(toCard(front, back, tags));

                                    front.clear();
                                    back.clear();
                                    tags.clear();

                                } else if (spaceCounter.get() == 1) {
                                    isAnswer.set(true);
                                }

                                if (isAnswer.get()) {

                                    final Set<String> back =
                                            (Set<String>) get(1);
                                    back.add(line);

                                } else {

                                    if (line.startsWith(TAGS_MARKER)) {

                                        extractTags(line, (Set<String>) get(2));

                                    } else {

                                        final Set<String> front =
                                                (Set<String>) get(0);
                                        front.add(StringUtil.rtrim(line));

                                    }

                                }

                                spaceCounter.reset();
                            }

                        }
                    };
            aabr.eachLine();
            action.execute(
                toCard(
                    (Set<String>) aabr.get(0),
                    (Set<String>) aabr.get(1),
                    (Set<String>) aabr.get(2)));

        } catch (final IOException ex) {
            Logger.getLogger(AnkiMainGui.class.getName()).log(
                Level.SEVERE,
                null,
                ex);
        }
    }


    private void extractTags(final String line, final Set<String> tags) {
        final String tagsStr = line.substring(TAGS_MARKER.length());

        final String[] cleanArray = StringUtil.trimArray(tagsStr.split(","));

        tags.addAll(Arrays.asList(cleanArray));
    }


    private Card toCard(final Set<String> front, final Set<String> back,
                        final Set<String> tags) {

        final Card newCard = new Card(
            StringUtil.join(front, "\n"),
            StringUtil.join(back, "\n"));

        newCard.addTags(tags.toArray(new String[tags.size()]));
        return newCard;
    }

}
